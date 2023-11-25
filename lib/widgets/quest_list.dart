import 'package:flutter/material.dart';
import 'package:sidequest/models/db.dart';
import 'package:sidequest/widgets/quest_tile.dart';

class QuestList extends StatelessWidget {
  const QuestList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: DB.instance.quests.length,
      itemBuilder: (context, index) {
        return QuestTile(DB.instance.quests.values.elementAt(index));
      },
    );
  }
}
