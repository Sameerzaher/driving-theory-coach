// import 'package:flutter/material.dart';
// import '../services/load_questions.dart'; // ודא שהקובץ עם הפונקציה loadTopics נמצא כאן

// class TopicsScreen extends StatefulWidget {
//   const TopicsScreen({super.key});

//   @override
//   State<TopicsScreen> createState() => _TopicsScreenState();
// }

// class _TopicsScreenState extends State<TopicsScreen> {
//   late Future<List<String>> topicsFuture;

//   @override
//   void initState() {
//     super.initState();
//     topicsFuture = loadTopics(); // טוען את רשימת הנושאים מתוך JSON
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("בחר נושא לתרגול")),
//       body: FutureBuilder<List<String>>(
//         future: topicsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('שגיאה: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('לא נמצאו נושאים'));
//           }

//           final topics = snapshot.data!;
//           return ListView.separated(
//             padding: const EdgeInsets.all(16),
//             itemCount: topics.length,
//             separatorBuilder: (_, __) => const SizedBox(height: 10),
//             itemBuilder: (context, index) {
//               return ElevatedButton(
//                 onPressed: () {
//                   // כאן בעתיד נעבור למסך שאלות של אותו נושא
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('בחרת את: ${topics[index]}')),
//                   );
//                 },
//                 child: Text(topics[index]),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }




import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'quiz_screen.dart';

class TopicsScreen extends StatefulWidget {
  const TopicsScreen({super.key});

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  List<String> _topics = [];

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    final String jsonData =
        await rootBundle.loadString('assets/theory_questions.json');
    final List<dynamic> data = json.decode(jsonData);

    final Set<String> topicsSet = {};
    for (var q in data) {
      if (q is Map && q['נושא'] != null) {
        topicsSet.add(q['נושא']);
      }
    }

    setState(() {
      _topics = topicsSet.toList()..sort(); // רשימה ממוינת
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('בחירת נושא')),
      body: _topics.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _topics.length,
              itemBuilder: (context, index) {
                final topic = _topics[index];
                return ListTile(
                  title: Text(topic, textAlign: TextAlign.right),
                  trailing: const Icon(Icons.chevron_left),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuizScreen(topic: topic),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
