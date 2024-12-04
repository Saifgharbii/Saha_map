import 'package:flutter/material.dart';

import '../home/CalendarPage.dart';
import '../home/MessagesPage.dart';
import 'SettingsPage.dart';

class NotificationsPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
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
    bottomNavigationBar: Container(
    color: Colors.blue.shade100,
    child: BottomNavigationBar(
    elevation: 0,
    selectedItemColor: Colors.blue,
    unselectedItemColor: Colors.black54,
    onTap: (index) {
    switch (index) {
    case 0:
    // Accueil
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
    case 3:
    // Profil
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SettingsPage()),
    );
    break;
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