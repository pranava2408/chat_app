import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageSender extends StatefulWidget {
  const MessageSender({super.key});
  @override
  State<MessageSender> createState() => _MessageSenderState();
}

class _MessageSenderState extends State<MessageSender> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose(); // Dispose the controller to free resources
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'Send a message',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () async {
              // Handle sending the message
              String message = _messageController.text.trim();
              if (message.isNotEmpty) {
                // Send the message logic here
                FocusScope.of(context).unfocus();
                print('Sending message: $message');
                _messageController.clear();
                // Clear the input field after sending
                //  we have to send the message to firebase cloud;

                final user = FirebaseAuth.instance.currentUser;
                final get =
                    await FirebaseFirestore.instance.collection('users').get();

                await FirebaseFirestore.instance.collection('chats').add({
                  'text': message,
                  'createdAt': Timestamp.now(),
                  'userId': user?.uid,
                  'username': get.docs
                      .firstWhere((doc) => doc.id == user?.uid)
                      .data()['username'],
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
