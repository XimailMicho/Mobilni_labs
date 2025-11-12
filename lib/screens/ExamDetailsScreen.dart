import 'package:flutter/material.dart';
import '../models/Exam.dart';

class ExamDetailScreen extends StatelessWidget {
  final Exam exam;

  const ExamDetailScreen({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final remaining = exam.dateTime.isBefore(now)
        ? 'Испитот е завршен'
        : '${exam.dateTime.difference(now).inDays} дена, ${exam.dateTime.difference(now).inHours % 24} саати';

    return Scaffold(
      appBar: AppBar(title: const Text('Детали на Испит')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exam.subject,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${exam.dateTime.day}.${exam.dateTime.month}.${exam.dateTime.year}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 18, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      '${exam.dateTime.hour.toString().padLeft(2, '0')}:${exam.dateTime.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on, size: 18, color: Colors.grey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        exam.classrooms.join(', '),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: exam.dateTime.isBefore(now)
                        ? Colors.grey[300]
                        : Colors.deepPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        exam.dateTime.isBefore(now)
                            ? Icons.check_circle_outline
                            : Icons.hourglass_bottom,
                        color: exam.dateTime.isBefore(now)
                            ? Colors.grey
                            : Colors.deepPurple,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Преостанато време: $remaining',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: exam.dateTime.isBefore(now)
                              ? Colors.grey[700]
                              : Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
