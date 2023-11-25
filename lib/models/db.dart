import 'dart:async';
import 'dart:convert';

import 'package:sidequest/models/job_scheduler.dart';
import 'package:sidequest/models/quest.dart';
import 'package:sidequest/utils/file_utils.dart';

class DB {
  DB._();
  static final DB _instance = DB._();
  static DB get instance => _instance;

  static const String fileName = 'DB.json';

  final StreamController _updateDbStreamController = StreamController.broadcast();
  Stream get updateDbStream => _updateDbStreamController.stream;

  bool _initialized = false;

  final Map<String, Quest> _quests = {};
  Map<String, Quest> get quests => _quests;

  final JobScheduler _jobScheduler = JobScheduler();

  Future<void> init() async {
    if (_initialized) return;

    final jsonString = await FileUtils.readLocalFile(fileName);

    if (jsonString.startsWith("ERROR:")) {
      throw Exception(jsonString);
    }

    if (jsonString.isEmpty) {
      _initialized = true;
      return;
    }

    final jsonData = jsonDecode(jsonString);

    for (var i = 0; i < jsonData['quests'].length; i++) {
      final quest = Quest.fromJson(jsonData['quests'][i]);
      _quests[quest.id] = quest;
    }

    _initialized = true;

    return;
  }

  Future<void> save() async {
    _updateDbStreamController.add(null);

    final jsonString = jsonEncode({
      'quests': _quests.values.map((e) => e.toJson()).toList(),
    });

    await FileUtils.writeLocalFile(fileName, jsonString);

    return;
  }

  void deleteQuest(Quest quest) {
    _quests.remove(quest.id);
    _jobScheduler.addJob(save);
  }

  /// This will add a new quest to the DB if it doesn't already exist
  void updateQuest(Quest quest) {
    _quests[quest.id] = quest;
    _jobScheduler.addJob(save);
  }
}
