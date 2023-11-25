class QuestTask {
  QuestTask({
    required this.name,
    required this.isComplete,
    this.description,
  });

  final String name;
  final String? description;
  final bool isComplete;

  factory QuestTask.fromJson(Map<String, dynamic> json) {
    return QuestTask(
      name: json['name'],
      isComplete: json['isComplete'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isComplete': isComplete,
      'description': description,
    };
  }
}
