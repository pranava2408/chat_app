import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .orderBy('createdAt', descending: false)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final messages = snapshot.data?.docs ?? [];

        return ListView.builder(
          reverse: false,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index].data() as Map<String, dynamic>;

            return ListTile(
              title: Text(message['text']),
              subtitle: Text(message['username']),
              trailing: Text(
                DateTime.fromMillisecondsSinceEpoch(
                  message['createdAt'].millisecondsSinceEpoch,
                ).toLocal().toString(),
              ),
            );
          },
        );
      },
    );
  }
}
