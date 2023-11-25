import 'package:flutter/material.dart';
import 'package:sidequest/models/db.dart';
import 'package:sidequest/screens/home.dart';
import 'package:system_theme/system_theme.dart';

void main() async {
  SystemTheme.fallbackColor = Colors.deepPurple;
  await SystemTheme.accentColor.load();
  await DB.instance.init();

  runApp(const SideQuest());
}

class SideQuest extends StatelessWidget {
  const SideQuest({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Side Quest',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: SystemTheme.accentColor.accent,
          brightness: MediaQuery.of(context).platformBrightness,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
