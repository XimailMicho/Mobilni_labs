import 'package:lab1/screens/ExamListScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ExamSchedulerApp());
}

class ExamSchedulerApp extends StatelessWidget {
  const ExamSchedulerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ExamListScreen(indexNumber: '221242'),
    );
  }
}