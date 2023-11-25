import 'package:latlong2/latlong.dart';
import 'package:sidequest/models/quest_task.dart';

enum QuestType { main, side, optional, repeating, event }

enum QuestCompletionCriteria { quantity, bool, location, tasks }

enum QuestStatus { active, completed, failed, notStarted }

class Quest {
  final String id;
  final String name;
  final String? description;
  final QuestType type;
  final QuestCompletionCriteria completionCriteria;
  final QuestStatus status;
  final DateTime? date;
  final LatLng? location;
  final dynamic goal;
  final dynamic currentValue;

  double get completionValue {
    switch (completionCriteria) {
      case QuestCompletionCriteria.quantity:
        return (goal as int) / (currentValue as int);
      case QuestCompletionCriteria.bool:
        return currentValue ? 1 : 0;
      case QuestCompletionCriteria.location:
        // TODO: implement location completion
        return 0;
      case QuestCompletionCriteria.tasks:
        return (goal as List<QuestTask>).where((element) => element.isComplete).length / (goal as List<QuestTask>).length;
    }
  }

  String get nextGoal {
    switch (completionCriteria) {
      case QuestCompletionCriteria.quantity:
        return '$currentValue / $goal';
      case QuestCompletionCriteria.bool:
        return currentValue ? 'Complete!' : 'Not Yet Complete';
      case QuestCompletionCriteria.location:
        return 'Go to $goal';
      case QuestCompletionCriteria.tasks:
        return (goal as List<QuestTask>).where((element) => !element.isComplete).first.name;
    }
  }

  Quest({
    required this.id,
    required this.name,
    this.description,
    required this.type,
    required this.completionCriteria,
    required this.status,
    this.date,
    this.location,
    this.goal,
    this.currentValue,
  }) {
    assert(goal != null);
    assert(type != QuestType.repeating || date != null);
    assert(type != QuestType.event || date != null);
    assert(type != QuestType.event || location != null);
    assert(completionCriteria != QuestCompletionCriteria.quantity || goal is int);
    assert(completionCriteria != QuestCompletionCriteria.quantity || currentValue is int);
    assert(completionCriteria != QuestCompletionCriteria.bool || goal is bool);
    assert(completionCriteria != QuestCompletionCriteria.location || goal is LatLng);
    assert(completionCriteria != QuestCompletionCriteria.tasks || goal is List<QuestTask>);
  }

  factory Quest.fromJson(Map<String, dynamic> json) {
    var goal = json['goal'];
    if (json['completionCriteria'] == QuestCompletionCriteria.tasks.index) {
      goal = (goal as List).map((e) => QuestTask.fromJson(e)).toList();
    }

    return Quest(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: QuestType.values[json['type']],
      completionCriteria: QuestCompletionCriteria.values[json['completionCriteria']],
      status: QuestStatus.values[json['status']],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      location: json['location'] != null ? LatLng(json['location']['latitude'], json['location']['longitude']) : null,
      goal: goal,
      currentValue: json['currentValue'],
    );
  }

  Map<String, dynamic> toJson() {
    var goal = this.goal;
    if (completionCriteria == QuestCompletionCriteria.tasks) {
      goal = (goal as List<QuestTask>).map((e) => e.toJson()).toList();
    }

    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.index,
      'completionCriteria': completionCriteria.index,
      'status': status.index,
      'date': date?.toIso8601String(),
      'location': location != null ? {'latitude': location!.latitude, 'longitude': location!.longitude} : null,
      'goal': goal,
      'currentValue': currentValue,
    };
  }
}
