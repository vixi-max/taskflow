
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const TaskFlowApp());
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF7657E8),
        scaffoldBackgroundColor: const Color(0xFFF7F6FC),
      ),
      home: const HomeScreen(),
    );
  }
}
