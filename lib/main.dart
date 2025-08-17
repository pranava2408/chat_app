import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
// import 'package:firebase_app_check_web/firebase_app_check_web.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.safetyNet,
  //   webProvider: ReCaptchaV3Provider('recaptcha-key'),
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App for fun',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.connectionState == ConnectionState.active) {
              final user = snapshot.data;
              if (user == null) {
                return HomeScreen(); // Show home screen f user is not signed in
              } else {
                return ChatScreen(); // Show chat screen if user is signed in
              }
            }
            return HomeScreen(); // Default to home screen
          }),
    );
  }
}
