// lib/pages/add_word_set_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/word_set.dart';

class AddWordSetPage extends StatefulWidget {
  @override
  _AddWordSetPageState createState() => _AddWordSetPageState();
}

class _AddWordSetPageState extends State<AddWordSetPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  bool _isLoading = false;

  Future<void> _addWordSet() async {
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) return;

    _formKey.currentState?.save();

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('wordSets').add({
        'title': _title,
        'description': _description,
      });

      Navigator.of(context).pop(); // Закрыть экран после добавления
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Набор слов добавлен успешно')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при добавлении набора: $error')),
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
        title: Text('Добавить набор слов'),
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
                  decoration: InputDecoration(labelText: 'Название набора'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, введите название набора';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _title = value!.trim();
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Описание набора'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, введите описание набора';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _description = value!.trim();
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addWordSet,
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
