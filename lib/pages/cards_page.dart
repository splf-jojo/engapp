// lib/pages/cards_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/word_set.dart';
import 'word_set_detail_page.dart'; // Импортируйте WordSetDetailPage
import 'add_word_set_page.dart'; // Импортируйте AddWordSetPage

class CardsPage extends StatefulWidget {
  @override
  _CardsPageState createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  List<WordSet> _wordSets = [];
  bool _isLoading = true;

  // Получение наборов слов из Firestore
  void _fetchWordSets() {
    FirebaseFirestore.instance.collection('wordSets').snapshots().listen((snapshot) {
      List<WordSet> wordSetsData = snapshot.docs.map((doc) {
        return WordSet.fromFirestore(doc.data(), doc.id);
      }).toList();

      setState(() {
        _wordSets = wordSetsData;
        _isLoading = false;
      });
    }, onError: (error) {
      print('Ошибка при получении наборов слов: $error');
      setState(() {
        _isLoading = false;
      });
      // Можно добавить отображение ошибки пользователю
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchWordSets();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text('Наборы слов'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddWordSetPage()),
              );
            },
            tooltip: 'Добавить набор слов',
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _wordSets.isEmpty
          ? Center(
        child: Text(
          'Нет доступных наборов слов',
          style: TextStyle(fontSize: 20, color: textColor),
        ),
      )
          : ListView.builder(
        itemCount: _wordSets.length,
        itemBuilder: (context, index) {
          final wordSet = _wordSets[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(wordSet.title),
              subtitle: Text(wordSet.description),
              trailing: Icon(
                Icons.arrow_forward,
                color: isDarkMode ? Colors.lightBlueAccent : Colors.blue,
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => WordSetDetailPage(wordSet: wordSet),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
