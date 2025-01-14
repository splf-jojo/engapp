// lib/pages/add_word_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/word_set.dart';

class AddWordPage extends StatefulWidget {
  final WordSet wordSet;

  AddWordPage({required this.wordSet});

  @override
  _AddWordPageState createState() => _AddWordPageState();
}

class _AddWordPageState extends State<AddWordPage> {
  final _formKey = GlobalKey<FormState>();
  String _word = '';
  String _translation = '';
  String _meaningEn = '';
  String _meaningRu = '';
  bool _isLoading = false;

  Future<void> _addWord() async {
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) return;

    _formKey.currentState?.save();

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('wordSets')
          .doc(widget.wordSet.id)
          .collection('words')
          .add({
        'word': _word,
        'translation': _translation,
        'meaningEn': _meaningEn,
        'meaningRu': _meaningRu,
      });

      Navigator.of(context).pop(); // Закрыть экран после добавления
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Слово добавлено успешно')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при добавлении слова: $error')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить слово в ${widget.wordSet.title}'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Слово'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, введите слово';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _word = value!.trim();
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Перевод'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, введите перевод';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _translation = value!.trim();
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Значение на английском'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, введите значение на английском';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _meaningEn = value!.trim();
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Значение на русском'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, введите значение на русском';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _meaningRu = value!.trim();
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addWord,
                  child: Text('Добавить'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
