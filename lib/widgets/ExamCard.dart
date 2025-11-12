import 'package:flutter/material.dart';
import '../models/Exam.dart';
import '../screens/ExamDetailsScreen.dart';

class ExamCard extends StatelessWidget {
  final Exam exam;
  const ExamCard({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isPast = exam.dateTime.isBefore(now);

    return Card(
      color: isPast ? Colors.yellow.shade50 : Colors.white,
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ExamDetailScreen(exam: exam)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(exam.subject, style: const TextStyle( fontSize: 18, fontWeight: FontWeight.bold))),
                  const Icon(Icons.arrow_forward_ios, size: 16)
                ],
              ),
              const SizedBox(height: 6),
              Row(children: [
                const Icon(Icons.date_range, size: 16),
                const SizedBox(width: 4),
                Text('${exam.dateTime.day}.${exam.dateTime.month}.${exam.dateTime.year} • ${exam.dateTime.hour.toString().padLeft(2, '0')}:${exam.dateTime.minute.toString().padLeft(2, '0')}')
              ]),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.place, size: 16),
                const SizedBox(width: 4),
                Text(exam.classrooms.join(', '))
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
