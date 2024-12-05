import 'package:flutter/material.dart';

import '../home/CalendarPage.dart';
import '../home/HomePage.dart';
import '../home/MessagesPage.dart';

class LanguePage extends StatelessWidget {
  final List<Map<String, String>> languages = [
    {'name': 'Français', 'flag': 'assets/flags/france.png'},
    {'name': 'English', 'flag': 'assets/flags/usa.png'},
    {'name': 'العربية', 'flag': 'assets/flags/tunisia.png'},
    {'name': 'Español', 'flag': 'assets/flags/spain.png'},
    {'name': 'Deutsch', 'flag': 'assets/flags/germany.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Langue',
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
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        itemCount: languages.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                leading: Image.asset(
                  languages[index]['flag']!,
                  width: 30,
                  height: 30,
                ),
                title: Text(
                  languages[index]['name']!,
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {
                  // Action pour changer la langue
                  print("Langue sélectionnée : ${languages[index]['name']}");
                },
              ),
              Divider(),
            ],
          );
        },
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
