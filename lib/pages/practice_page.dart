import 'package:flutter/material.dart';
import 'practice_test_page.dart';

class PracticePage extends StatelessWidget {
  // Список тренировочных наборов
  final List<Map<String, dynamic>> practiceSets = [
    {
      'title': 'Practice Panda 1',
      'icon': Icons.pets, // Иконка панды условно, можно взять другую
      'questions': [
        {
          'question': 'What is the capital of France?',
          'answers': ['Paris', 'London', 'Berlin', 'Rome'],
          'correctIndex': 0
        },
        {
          'question': '2 + 2 = ?',
          'answers': ['3', '4', '5', '6'],
          'correctIndex': 1
        },
        {
          'question': 'Color of the sky?',
          'answers': ['Blue', 'Red', 'Green', 'Yellow'],
          'correctIndex': 0
        },
      ]
    },
    {
      'title': 'Practice Princeton 1',
      'icon': Icons.school, // Иконка университета
      'questions': [
        {
          'question': 'Who wrote "Hamlet"?',
          'answers': ['Shakespeare', 'Tolstoy', 'Hemingway', 'Dante'],
          'correctIndex': 0
        },
        {
          'question': 'What is H2O?',
          'answers': ['Gold', 'Oxygen', 'Water', 'Hydrogen'],
          'correctIndex': 2
        },
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('Practice'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: practiceSets.length,
        itemBuilder: (context, index) {
          final set = practiceSets[index];
          return ListTile(
            title: Text(set['title']),
            trailing: Icon(set['icon'], color: isDarkMode ? Colors.grey[300] : Colors.blue),
            onTap: () {
              // Переход к PracticeTestPage с передачей списка вопросов
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PracticeTestPage(
                    questions: List<Map<String, dynamic>>.from(set['questions']),
                    title: set['title'],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
