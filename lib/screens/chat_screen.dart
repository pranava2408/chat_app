import 'package:chat_app/widgets/chat_messages.dart';
import 'package:chat_app/widgets/message_sender.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatApp'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ChatMessages(
                  currentUserId: _auth.currentUser!.uid.toString())),
          // SizedBox(height: 20),
          // SizedBox(height: double.infinity),
          // const Spacer(),
          Expanded(child: MessageSender()),
        ],
      ),
    );
  }
}
