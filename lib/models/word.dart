// lib/models/word.dart
class Word {
  final String id;
  final String word;
  final String translation;
  final String meaningEn;
  final String meaningRu;

  Word({
    required this.id,
    required this.word,
    required this.translation,
    required this.meaningEn,
    required this.meaningRu,
  });

  // Фабричный метод для создания объекта Word из документа Firestore
  factory Word.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Word(
      id: documentId,
      word: data['word'] ?? '',
      translation: data['translation'] ?? '',
      meaningEn: data['meaningEn'] ?? '',
      meaningRu: data['meaningRu'] ?? '',
    );
  }

  // Метод для преобразования объекта Word в Map для записи в Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'word': word,
      'translation': translation,
      'meaningEn': meaningEn,
      'meaningRu': meaningRu,
    };
  }
}
