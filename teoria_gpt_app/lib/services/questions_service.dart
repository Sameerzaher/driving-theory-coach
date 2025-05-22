import 'dart:convert';
import 'package:flutter/services.dart';

class Question {
  final int id;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String topic;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.topic,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['מספר השאלה במאגר'],
      question: json['השאלה'],
      options: [
        json['תשובה 1'],
        json['תשובה 2'],
        json['תשובה 3'],
        json['תשובה 4'],
      ],
      correctAnswer: json['מספר התשובה הנכונה'],
      topic: json['נושא'] ?? 'לא מוגדר',
    );
  }
}

class QuestionService {
  static Future<List<Question>> loadQuestions() async {
    final data = await rootBundle.loadString('assets/theory_questions.json');
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((e) => Question.fromJson(e)).toList();
  }
}
