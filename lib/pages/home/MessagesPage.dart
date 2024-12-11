import 'package:flutter/material.dart';

import 'CalendarPage.dart';
import 'HomePage.dart';
import '../profile/SettingsPage.dart';
import 'message.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Messagerie',
          style: TextStyle(color: Colors.teal),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Barre de recherche pour filtrer les conversations
            TextField(
              decoration: InputDecoration(
                hintText: "Rechercher une discussion",
                prefixIcon: const Icon(Icons.search, color: Colors.teal),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Liste des discussions
            ConversationCard(
              name: "Dr. Rim Maala",
              specialty: "Psychiatrie",
              lastMessage: "Oui, merci madame.",
              avatar: 'assets/images/doctor1.webp',
              time: "15:45",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MessageDetailsPage(
                      name: "Dr. Rim Maala",
                      avatar: 'assets/images/doctor1.webp',
                      messages: const [
                        {
                          'isMe': false,
                          'text': "Bonjour, avez-vous reçu vos résultats ?",
                          'time': "15:45",
                          'type': 'text'
                        },
                        {
                          'isMe': true,
                          'text': "Oui, merci madame.",
                          'time': "16:00",
                          'type': 'text'
                        },
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
            ConversationCard(
              name: "Dr. Sami Fourti",
              specialty: "Cardiologie",
              lastMessage: "Appel vocal terminé",
              avatar: 'assets/images/doctor2.jpg',
              time: "12:30",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MessageDetailsPage(
                      name: "Dr. Sami Fourti",
                      avatar: 'assets/images/doctor2.jpg',
                      messages: const [
                        {
                          'isMe': false,
                          'text': "Je peux vous voir jeudi prochain.",
                          'time': "16:00",
                          'type': 'text'
                        },
                        {'isMe': true,
                          'text': '',
                          'time': '19:50',
                          'type': 'call',
                          'callDuration': '10 min 24 s'
                        }
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ConversationCard(
              name: "Clinique La Rose",
              specialty: "Cardiologie",
              lastMessage: "C’est parfait, n’hésitez pas à nous contacter si vous avez d’autres questions. Bonne journée.",
              avatar: 'assets/images/rose.jpg',
              time: "09:00",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MessageDetailsPage(
                      name: "Clinique La Rose",
                      avatar: 'assets/images/rose.jpg',
                      messages: const [
                        {
                          'isMe': true,
                          'text': "Bonjour, je souhaiterais confirmer mon rendez-vous de demain matin avec le cardiologue.",
                          'time': "15:45",
                          'type': 'text'
                        },
                        {
                          'isMe': false,
                          'text': "Bonjour, votre rendez-vous est bien confirmé pour demain à 10h avec le Dr. Sami Fourti. Avez-vous des documents ou des examens à apporter ?",
                          'time': "16:00",
                          'type': 'text'
                        },
                        {
                          'isMe': true,
                          'text': "Merci. Oui, je vais apporter mes derniers résultats d’analyse sanguine",
                          'time': "15:45",
                          'type': 'text'
                        },
                        {
                          'isMe': false,
                          'text': "C’est parfait, n’hésitez pas à nous contacter si vous avez d’autres questions. Bonne journée.",
                          'time': "16:00",
                          'type': 'text'
                        },
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ConversationCard(
              name: "Dr. Narjess Hadj Mohamed",
              specialty: "Cardiologie",
              lastMessage: "Appel vidéo terminé",
              avatar: 'assets/images/doctor7.jpg',
              time: "mardi",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MessageDetailsPage(
                      name: "Dr. Narjes Hadj Mohamed",
                      avatar: 'assets/images/doctor7.jpg',
                      messages: const [
                        {'isMe': false,
                          'text': '',
                          'time': '19:50',
                          'type': 'videocall',
                          'callDuration': '10 min 24 s'}
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ConversationCard(
              name: "Dr. Sirine Charrada",
              specialty: "Dermatologie",
              lastMessage: "Oui, merci madame.",
              avatar: 'assets/images/doctor3.jpg',
              time: "lundi",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MessageDetailsPage(
                      name: "Dr. Sirine Charrada",
                      avatar: 'assets/images/doctor3.jpg',
                      messages: const [
                        {
                          'isMe': true,
                          'text': "Bonjour Docteur, mon problème de peau s’aggrave malgré les soins. Que me conseillez-vous ?",
                          'time': "15:45",
                          'type': 'text'
                        },
                        {
                          'isMe': false,
                          'text': "Bonjour, Amal. Pouvez-vous me décrire les symptômes ou m’envoyer une photo pour que je puisse mieux comprendre la situation ?",
                          'time': "16:00",
                          'type': 'text'
                        },
                        {
                          'isMe': true,
                          'text': "",
                          'time': "16:10",
                          'type': 'image',
                          'imageUrl': 'assets/images/example.jfif', // Chemin de l'image
                        },
                        {
                          'isMe': false,
                          'text': "Merci pour la photo. Je vous recommande d’appliquer la crème prescrite deux fois par jour et d’éviter toute exposition au soleil pendant quelques jours. Tenez-moi informée.",
                          'time': "15:45",
                          'type': 'text'
                        },
                        {
                          'isMe': true,
                          'text': "Oui, merci madame.",
                          'time': "16:00",
                          'type': 'text'
                        },
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black54,
        currentIndex: 2, // Index correspondant à la page "Messagerie"
        onTap: (index) {
          switch (index) {
          case 0:
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage())
          );
          break;
          case 1:
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CalendarPage())
          );
          break;
          case 2:
          break;
          case 3:
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsPage())
          );
          break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Agenda"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Messagerie"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Paramètres"),
        ],
      ),
    );
  }
}

class ConversationCard extends StatelessWidget {
  final String name;
  final String specialty;
  final String lastMessage;
  final String avatar;
  final String time;
  final VoidCallback onTap;

  const ConversationCard({super.key, 
    required this.name,
    required this.specialty,
    required this.lastMessage,
    required this.avatar,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(avatar),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(color: Colors.teal,fontWeight: FontWeight.bold)),
                    Text(specialty, style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 8),
                    Text(lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              Text(time, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}

