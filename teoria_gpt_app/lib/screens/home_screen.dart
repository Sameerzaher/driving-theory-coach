import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  final String userName;
  final String subscriptionStatus;

  const HomeScreen({
    required this.userName,
    required this.subscriptionStatus,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ברוך הבא, $userName'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            tooltip: 'התנתק',
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('סטטוס מנוי: $subscriptionStatus',
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/topics'),
              icon: Icon(Icons.list),
              label: Text('תרגול לפי נושא'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/exam'),
              icon: Icon(Icons.assignment),
              label: Text('מבחן מלא'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/chat'),
              icon: Icon(Icons.chat),
              label: Text('דבר עם GPT'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/progress'),
              icon: Icon(Icons.bar_chart),
              label: Text('התקדמות אישית'),
            ),
          ],
        ),
      ),
    );
  }
}
