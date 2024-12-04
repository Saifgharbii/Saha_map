import 'package:flutter/material.dart';

import '../home/CalendarPage.dart';
import '../home/MessagesPage.dart';
import 'SettingsPage.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Centre d\'Aide',
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
            leading: Icon(Icons.question_answer, color: Colors.teal),
            title: Text(
              'FAQ',
              style: TextStyle(fontSize: 16),
            ),
            trailing: Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              // Action pour afficher les FAQ
              print("FAQ sélectionnée");
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.chat, color: Colors.teal),
            title: Text(
              'Contactez l\'Assistance',
              style: TextStyle(fontSize: 16),
            ),
            trailing: Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              // Action pour contacter l'assistance
              print("Contact Assistance sélectionné");
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.report_problem, color: Colors.teal),
            title: Text(
              'Signaler un problème',
              style: TextStyle(fontSize: 16),
            ),
            trailing: Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              // Action pour signaler un problème
              print("Signaler un problème sélectionné");
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info, color: Colors.teal),
            title: Text(
              'À propos',
              style: TextStyle(fontSize: 16),
            ),
            trailing: Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              // Action pour afficher les informations sur l'application
              print("À propos sélectionné");
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

