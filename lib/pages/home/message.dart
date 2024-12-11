import 'package:flutter/material.dart';

class MessageDetailsPage extends StatelessWidget {
  final String name;
  final String avatar;
  final List<Map<String, dynamic>> messages;

  const MessageDetailsPage({super.key, 
    required this.name,
    required this.avatar,
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(avatar),
            ),
            const SizedBox(width: 10),
            Text(
              name,
              style: const TextStyle(color: Colors.teal,fontSize: 12,),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Colors.teal),
            onPressed: () {
              print("Appel audio avec $name");
            },
          ),
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.teal),
            onPressed: () {
              print("Appel vidéo avec $name");
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            return MessageBubble(
              isMe: message['isMe'],
              message: message['text'],
              time: message['time'],
              type: message['type'], // Ajoutez un type pour chaque message
              callDuration: message['callDuration'], // Durée de l'appel
              imageUrl: message['imageUrl'], // URL de l'image
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.camera_alt, color: Colors.teal),
                onPressed: () {
                  print("Caméra activée");
                },
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Écrire un message...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.teal),
                onPressed: () {
                  print("Message envoyé");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final bool isMe;
  final String message;
  final String time;
  final String? type; // Type du message : 'text', 'call', 'videocall', 'image'
  final String? callDuration; // Durée de l'appel
  final String? imageUrl; // URL de l'image

  const MessageBubble({super.key, 
    required this.isMe,
    required this.message,
    required this.time,
    this.type = 'text',
    this.callDuration,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (type == 'call') {
      return Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.call,
                color: Colors.teal,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Appel vocal",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (callDuration != null)
                    Text(
                      callDuration!,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                ],
              ),
            ],
          ),
        ),
      );
    } else if (type == 'videocall') {
      return Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.videocam,
                color: Colors.blue,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Appel vidéo",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (callDuration != null)
                    Text(
                      callDuration!,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                ],
              ),
            ],
          ),
        ),
      );
    } else if (type == 'image') {
      return Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                imageUrl ?? '',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
              if (message.isNotEmpty)
                Text(
                  message,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
            ],
          ),
        ),
      );
    } else {
      return Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: isMe ? Colors.blue : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                message,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black,
                ),
              ),
            ),
            Text(
              time,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }
  }
}

