import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class EmailLoginScreen extends StatefulWidget {
  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        print('שגיאה: \${e.message}');
      }
    }
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return; // ביטול התחברות
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'אימייל'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'סיסמה'),
              obscureText: true,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: signIn,
              child: Text('התחבר / הירשם'),
            ),
            SizedBox(height: 16),
            Divider(),
            ElevatedButton.icon(
              onPressed: signInWithGoogle,
              icon: Icon(Icons.login),
              label: Text('התחבר עם Google'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            ),
          ],
        ),
      ),
    );
  }
}