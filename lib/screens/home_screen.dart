import 'package:chat_app/widgets/custom_buttom.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/screens/signup_screen.dart';
import 'package:chat_app/screens/signin_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
        backgroundColor: const Color.fromARGB(255, 90, 199, 219),
      ),
      backgroundColor: const Color.fromARGB(255, 159, 134, 228),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the Chat App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            CustomButtom(
                text: 'Sign In',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SigninScreen()),
                  );
                }),
            SizedBox(height: 10),
            CustomButtom(
                text: 'Sign Up',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupScreen()),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
