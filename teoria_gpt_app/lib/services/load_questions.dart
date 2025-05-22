import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:teoria_gpt_app/models/question.dart';

Future<List<Question>> loadQuestions() async {
  final String jsonString = await rootBundle.loadString('assets/questions.json');
  final List<dynamic> jsonData = json.decode(jsonString);
  return jsonData.map((e) => Question.fromJson(e)).toList();
}

Future<List<String>> loadTopics() async {
  final String jsonString = await rootBundle.loadString('assets/theory_questions.json');
  final List<dynamic> jsonData = json.decode(jsonString);
  final topics = jsonData.map((e) => e['נושא'] as String).toSet().toList();
  return topics;
}
