import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For time formatting

class ChatMessages extends StatelessWidget {
  final String currentUserId;

  const ChatMessages({super.key, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .orderBy('createdAt', descending: true) // Changed to descending
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final messages = snapshot.data?.docs ?? [];
        
        return ListView.builder(
          reverse: true, // Keeps latest message at bottom
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index].data() as Map<String, dynamic>;
            final isMe = message['userId'] == currentUserId;
            
            return MessageBubble(
              message: message,
              isMe: isMe,
            );
          },
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final timestamp = (message['createdAt'] as Timestamp).toDate();
    final timeString = DateFormat('h:mm a').format(timestamp);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            // Other user's avatar placeholder
            const CircleAvatar(
              child: Icon(Icons.person),
              radius: 16,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 14,
              ),
              decoration: BoxDecoration(
                color: isMe 
                  ? Theme.of(context).primaryColor 
                  : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isMe ? 18 : 0),
                  bottomRight: Radius.circular(isMe ? 0 : 18),
                ),
              ),
              child: Column(
                crossAxisAlignment: isMe 
                    ? CrossAxisAlignment.end 
                    : CrossAxisAlignment.start,
                children: [
                  // Username for others
                  if (!isMe)
                    Text(
                      message['username'] ?? 'Unknown',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isMe ? Colors.white : Colors.black87,
                      ),
                    ),
                  Text(
                    message['text'] ?? '',
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeString,
                    style: TextStyle(
                      color: isMe ? Colors.white70 : Colors.black54,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            // Current user's avatar placeholder
            const CircleAvatar(
              child: Icon(Icons.person),
              radius: 16,
            ),
          ],
        ],
      ),
    );
  }
}