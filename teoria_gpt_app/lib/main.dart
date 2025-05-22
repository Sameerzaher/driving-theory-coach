import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/login_screen.dart'; // מסך התחברות באימייל
import 'screens/home_screen.dart';  // מסך בית האמיתי שלך עם הכפתורים

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'מאמן תאוריה GPT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Arial',
      ),
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(),
      routes: {
        '/topics': (_) => PlaceholderScreen(title: 'תרגול לפי נושא'),
        '/exam': (_) => PlaceholderScreen(title: 'מבחן מלא'),
        '/chat': (_) => PlaceholderScreen(title: 'דבר עם GPT'),
        '/progress': (_) => PlaceholderScreen(title: 'התקדמות אישית'),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasData) {
          final user = snapshot.data!;
          return HomeScreen(
            userName: user.displayName ?? user.email ?? 'תלמיד',
            subscriptionStatus: 'פעיל', // תוכל לשלוף מפיירסטור בהמשך
          );
        } else {
          return EmailLoginScreen(); // מסך התחברות באימייל
        }
      },
    );
  }
}

// מסך זמני – להחליף בהמשך בגרסאות אמיתיות
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({required this.title, super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title נמצא בפיתוח')),
    );
  }
}
