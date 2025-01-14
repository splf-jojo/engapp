// lib/pages/word_set_detail_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/word_set.dart';
import '../models/word.dart';
import 'package:flip_card/flip_card.dart';
import 'add_word_page.dart'; // Импортируйте AddWordPage

class WordSetDetailPage extends StatefulWidget {
  final WordSet wordSet;

  WordSetDetailPage({required this.wordSet});

  @override
  _WordSetDetailPageState createState() => _WordSetDetailPageState();
}

class _WordSetDetailPageState extends State<WordSetDetailPage> {
  List<Word> _words = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  // Получение слов из подколлекции 'words' выбранного набора
  void _fetchWords() {
    FirebaseFirestore.instance
        .collection('wordSets')
        .doc(widget.wordSet.id)
        .collection('words')
        .snapshots()
        .listen((snapshot) {
      List<Word> wordsData = snapshot.docs.map((doc) {
        return Word.fromFirestore(doc.data(), doc.id);
      }).toList();

      setState(() {
        _words = wordsData;
        _isLoading = false;
        if (_currentIndex >= _words.length) {
          _currentIndex = 0;
        }
      });
    }, onError: (error) {
      print('Ошибка при получении слов: $error');
      setState(() {
        _isLoading = false;
      });
      // Можно добавить отображение ошибки пользователю
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchWords();
  }

  void _nextWord() {
    if (_words.isEmpty) return;
    setState(() {
      _currentIndex = (_currentIndex + 1) % _words.length;
    });
  }

  void _prevWord() {
    if (_words.isEmpty) return;
    setState(() {
      _currentIndex = (_currentIndex - 1 + _words.length) % _words.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardBackgroundColor = isDarkMode ? Colors.grey[800] : Colors.blue[100];
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final double progress = (_words.length > 1)
        ? (_currentIndex) / (_words.length - 1)
        : 1.0; // Избегаем деления на ноль

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.wordSet.title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddWordPage(wordSet: widget.wordSet),
                ),
              );
            },
            tooltip: 'Добавить слово',
          ),
        ],
      ),
      body: Column(
        children: [
          // Прогресс-бар сверху
          LinearProgressIndicator(
            value: progress.isNaN ? 0.0 : progress,
            color: Colors.blue,
            backgroundColor: Colors.grey[300],
          ),
          Expanded(
            child: Center(
              child: _isLoading
                  ? CircularProgressIndicator()
                  : _words.isEmpty
                  ? Text(
                'Нет доступных слов в этом наборе',
                style: TextStyle(fontSize: 20, color: textColor),
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlipCard(
                    speed: 700, // Скорость анимации
                    front: Container(
                      width: 350,
                      height: 300,
                      decoration: BoxDecoration(
                        color: cardBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _words[_currentIndex].word,
                              style: TextStyle(fontSize: 30, color: textColor),
                            ),
                            SizedBox(height: 10),
                            Text(
                              _words[_currentIndex].translation,
                              style: TextStyle(fontSize: 20, color: textColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    back: Container(
                      width: 350,
                      height: 300,
                      decoration: BoxDecoration(
                        color: cardBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Meaning in English:',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                _words[_currentIndex].meaningEn,
                                style: TextStyle(fontSize: 18, color: textColor),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Значение на русском:',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                _words[_currentIndex].meaningRu,
                                style: TextStyle(fontSize: 18, color: textColor),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _prevWord,
                        icon: Icon(Icons.arrow_back),
                        color: isDarkMode ? Colors.grey[400] : Colors.blue,
                      ),
                      SizedBox(width: 150),
                      IconButton(
                        onPressed: _nextWord,
                        icon: Icon(Icons.arrow_forward),
                        color: isDarkMode ? Colors.grey[400] : Colors.blue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
