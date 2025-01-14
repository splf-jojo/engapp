// lib/models/word_set.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'word.dart';

class WordSet {
  final String id;
  final String title;
  final String description;

  WordSet({
    required this.id,
    required this.title,
    required this.description,
  });

  // Фабричный метод для создания объекта WordSet из документа Firestore
  factory WordSet.fromFirestore(Map<String, dynamic> data, String documentId) {
    return WordSet(
      id: documentId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
    );
  }

  // Метод для преобразования объекта WordSet в Map для записи в Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
    };
  }
}
