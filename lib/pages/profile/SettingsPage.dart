import 'package:flutter/material.dart';

import '../home/HomePage.dart';
import 'NotificationsPage.dart';
import 'LanguePage.dart';
import '../home/CalendarPage.dart';
import '../home/MessagesPage.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Paramètres',
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
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        children: [
          ListTile(
            leading: const Icon(Icons.language, color: Colors.teal),
            title: const Text(
              'Langue',
              style: TextStyle(fontSize: 16),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LanguePage()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications, color: Colors.teal),
            title: const Text(
              'Notification',
              style: TextStyle(fontSize: 16),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsPage()),
              );
            },
          ),
          const Divider(),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.blue.shade100,
        child: BottomNavigationBar(
          elevation: 0,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black54,
          currentIndex: 3, // Indique que "Paramètres" est l'onglet actif
          onTap: (index) {
            if (index != 3) { // Empêche de recharger la page actuelle
              switch (index) {
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                  break;
                case 1:
                // Agenda
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CalendarPage()),
                  );
                  break;
                case 2:
                // Messagerie
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MessagesPage()),
                  );
                  break;
              }
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Agenda"),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Messagerie"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Paramètres"),
          ],
        ),
      ),
    );
  }
}

