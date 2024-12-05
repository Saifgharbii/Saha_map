import 'package:flutter/material.dart';

import '../home/CalendarPage.dart';
import '../home/HomePage.dart';
import '../home/MessagesPage.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Les états des boutons
  bool isNotificationsEnabled = true;
  bool isDailyRemindersEnabled = false;
  bool isEmailNotificationsEnabled = true;
  bool isDoNotDisturbEnabled = false;

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
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        children: [
          ListTile(
            leading: Icon(Icons.notifications_active, color: Colors.teal),
            title: Text(
              'Activer les notifications',
              style: TextStyle(fontSize: 16),
            ),
            trailing: Switch(
              value: isNotificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  isNotificationsEnabled = value;
                });
                print("Notifications activées : $value");
              },
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.alarm, color: Colors.teal),
            title: Text(
              'Rappels quotidiens',
              style: TextStyle(fontSize: 16),
            ),
            trailing: Switch(
              value: isDailyRemindersEnabled,
              onChanged: (bool value) {
                setState(() {
                  isDailyRemindersEnabled = value;
                });
                print("Rappels quotidiens : $value");
              },
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.email, color: Colors.teal),
            title: Text(
              'Notifications par email',
              style: TextStyle(fontSize: 16),
            ),
            trailing: Switch(
              value: isEmailNotificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  isEmailNotificationsEnabled = value;
                });
                print("Notifications email : $value");
              },
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.do_not_disturb, color: Colors.teal),
            title: Text(
              'Mode Ne Pas Déranger',
              style: TextStyle(fontSize: 16),
            ),
            trailing: Switch(
              value: isDoNotDisturbEnabled,
              onChanged: (bool value) {
                setState(() {
                  isDoNotDisturbEnabled = value;
                });
                print("Mode Ne Pas Déranger : $value");
              },
            ),
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
