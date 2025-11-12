import 'package:flutter/material.dart';
import '../models/Exam.dart';
import '../widgets/ExamCard.dart';

class ExamListScreen extends StatelessWidget {
  final String indexNumber;
  const ExamListScreen({super.key, required this.indexNumber});

  @override
  Widget build(BuildContext context) {
    final exams = [
      Exam(subject: 'Веројатност и статистика', dateTime: DateTime(2025, 1, 12, 10, 0), classrooms: ['Барака 2.2']),
      Exam(subject: 'Вештачка интелигенција', dateTime: DateTime(2025, 1, 14, 12, 0), classrooms: ['Барака 2.1', '2.3']),
      Exam(subject: 'Криптовалути и блоковски вериги', dateTime: DateTime(2025, 1, 15, 9, 0), classrooms: ['Барака 1']),
      Exam(subject: 'Оперативни системи', dateTime: DateTime(2025, 1, 17, 11, 0), classrooms: ['Барака 2.2']),
      Exam(subject: 'Алгоритми и податочни структури', dateTime: DateTime(2025, 1, 19, 13, 0), classrooms: ['Амфитеатар ФИНКИ']),
      Exam(subject: 'Веб програмирање', dateTime: DateTime(2025, 1, 21, 10, 30), classrooms: ['Амфитеатар ФИНКИ']),
      Exam(subject: 'Калкулус', dateTime: DateTime(2026, 3, 23, 8, 0), classrooms: ['112']),
      Exam(subject: 'Структурно програмирање', dateTime: DateTime(2026, 4, 25, 9, 30), classrooms: ['Барака 2.1']),
      Exam(subject: 'Бази на податоци', dateTime: DateTime(2025, 1, 27, 11, 30), classrooms: ['Барака 1', '3']),
      Exam(subject: 'Континуирана интеграција и испорака', dateTime: DateTime(2026, 5, 29, 14, 0), classrooms: ['Барака 1']),
    ]..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return Scaffold(
      appBar: AppBar(title: Text('Распоред за испити - $indexNumber')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: exams.length,
              itemBuilder: (context, index) => ExamCard(exam: exams[index]),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Chip(label: Text('Вкупно испити: ${exams.length}')),
          ),
        ],
      ),
    );
  }
}
