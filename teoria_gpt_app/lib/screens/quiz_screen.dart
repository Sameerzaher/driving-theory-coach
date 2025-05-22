import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class QuizScreen extends StatefulWidget {
  final String topic;

  const QuizScreen({required this.topic, Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, dynamic>> _questions = [];
  int _currentIndex = 0;
  String? _selectedAnswer;
  bool _isAnswered = false;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final String jsonData =
        await rootBundle.loadString('assets/theory_questions.json');
    final List<dynamic> data = json.decode(jsonData);
    final filtered = data.where((q) => q['נושא'] == widget.topic).toList();

    setState(() {
      _questions = filtered.cast<Map<String, dynamic>>();
    });
  }

  void _checkAnswer(String answer) {
    final correctIndex = _questions[_currentIndex]['מספר התשובה הנכונה'];
    final correctAnswer = _questions[_currentIndex]['תשובה $correctIndex'];

    setState(() {
      _selectedAnswer = answer;
      _isAnswered = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (_currentIndex + 1 < _questions.length) {
        setState(() {
          _currentIndex++;
          _selectedAnswer = null;
          _isAnswered = false;
        });
      } else {
        _showEndDialog();
      }
    });
  }

  void _showEndDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('סיום התרגול'),
        content: const Text('עברת על כל השאלות בנושא זה. כל הכבוד!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // סגור את הדיאלוג
              Navigator.pop(context); // חזור למסך הקודם
            },
            child: const Text('חזרה'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('שאלות בנושא: ${widget.topic}')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final question = _questions[_currentIndex];
    final correctIndex = question['מספר התשובה הנכונה'];
    final correctAnswer = question['תשובה $correctIndex'];

    return Scaffold(
      appBar: AppBar(
        title: Text('שאלה ${_currentIndex + 1} מתוך ${_questions.length}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              question['שאלה'] ?? '',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 24),
            for (var i = 1; i <= 4; i++)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: !_isAnswered
                      ? null
                      : (question['תשובה $i'] == correctAnswer
                          ? Colors.green
                          : (_selectedAnswer == question['תשובה $i']
                              ? Colors.red
                              : null)),
                ),
                onPressed: _isAnswered
                    ? null
                    : () => _checkAnswer(question['תשובה $i']),
                child: Text(question['תשובה $i'] ?? ''),
              ),
          ],
        ),
      ),
    );
  }
}
