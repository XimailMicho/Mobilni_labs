
import 'package:flutter/material.dart';

import 'lab1/screens/ExamListScreen.dart';
import 'lab2/screens/categoryScreen.dart';


void main() {
  runApp(const CategoryShowerApp());
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

class CategoryShowerApp extends StatelessWidget {
  const CategoryShowerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // removes the debug banner
      title: 'Category Shower App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CategoryScreen(), // This will be the first screen
    );
  }
}