import 'package:flutter/material.dart';

import '../home/HomePage.dart';
import 'NotificationsPage.dart';
import 'LanguePage.dart';
import '../home/CalendarPage.dart';
import '../home/MessagesPage.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Paramètres',
          style: TextStyle(color: Colors.teal),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        children: [
          ListTile(
            leading: Icon(Icons.language, color: Colors.teal),
            title: Text(
              'Langue',
              style: TextStyle(fontSize: 16),
            ),
            trailing: Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LanguePage()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.teal),
            title: Text(
              'Notification',
              style: TextStyle(fontSize: 16),
            ),
            trailing: Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsPage()),
              );
            },
          ),
          Divider(),
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
                    MaterialPageRoute(builder: (context) => HomePage(userName: '', userAvatar: '',)),
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
          items: [
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

