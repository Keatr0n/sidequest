import 'package:flutter/material.dart';
import 'package:sidequest/models/quest.dart';

class QuestTile extends StatelessWidget {
  const QuestTile(this.quest, {super.key});

  final Quest quest;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      // I need a progress bar as a background and the name and next task / completion criteria as the foreground
      child: Stack(
        children: [
          LinearProgressIndicator(
            value: quest.completionValue,
            backgroundColor: Theme.of(context).colorScheme.surface,
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.secondary),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quest.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  quest.nextGoal,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
