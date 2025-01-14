import 'package:flutter/material.dart';

class PracticeTestPage extends StatefulWidget {
  final List<Map<String, dynamic>> questions; // вопросы с ответами
  final String title;

  PracticeTestPage({required this.questions, required this.title});

  @override
  _PracticeTestPageState createState() => _PracticeTestPageState();
}

class _PracticeTestPageState extends State<PracticeTestPage> {
  int _currentQuestionIndex = 0;
  List<int?> _selectedAnswers = []; // будет хранить индексы выбранных ответов
  // null, если ответ не выбран

  @override
  void initState() {
    super.initState();
    _selectedAnswers = List<int?>.filled(widget.questions.length, null);
  }

  void _goNext() {
    if (_currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  void _goPrevious() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _finishTest() {
    // Подсчёт правильных ответов
    int correctCount = 0;
    for (int i = 0; i < widget.questions.length; i++) {
      final correctIndex = widget.questions[i]['correctIndex'] as int;
      if (_selectedAnswers[i] == correctIndex) {
        correctCount++;
      }
    }

    // Показываем диалог с результатами
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Result'),
        content: Text('You got $correctCount out of ${widget.questions.length} correct.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Закрыть диалог
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final questionData = widget.questions[_currentQuestionIndex];
    final questionText = questionData['question'] as String;
    final answers = questionData['answers'] as List<String>;
    final selectedAnswer = _selectedAnswers[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Вопрос
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              questionText,
              style: TextStyle(fontSize: 20, color: isDarkMode ? Colors.white : Colors.black),
            ),
          ),
          // Список ответов
          Expanded(
            child: ListView.builder(
              itemCount: answers.length,
              itemBuilder: (context, i) {
                return RadioListTile<int>(
                  title: Text(answers[i],
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                  value: i,
                  groupValue: selectedAnswer,
                  onChanged: (value) {
                    setState(() {
                      _selectedAnswers[_currentQuestionIndex] = value;
                    });
                  },
                );
              },
            ),
          ),
          // Кнопки
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Кнопка Назад
                IconButton(
                  onPressed: _currentQuestionIndex > 0 ? _goPrevious : null,
                  icon: Icon(Icons.arrow_back),
                  color: isDarkMode ? Colors.grey[400] : Colors.blue,
                ),
                SizedBox(width: 20),

                // Если это последний вопрос, то кнопка "Завершить"
                // иначе "Вперёд"
                if (_currentQuestionIndex == widget.questions.length - 1)
                  ElevatedButton(
                    onPressed: _finishTest,
                    child: Text('Finish'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode ? Colors.grey[700] : Colors.blue,
                    ),
                  )
                else
                  IconButton(
                    onPressed: _goNext,
                    icon: Icon(Icons.arrow_forward),
                    color: isDarkMode ? Colors.grey[400] : Colors.blue,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
