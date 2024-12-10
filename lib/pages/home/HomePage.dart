import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saha_map/models/models.dart';
import 'appointment/AppointmentPage.dart';
import '../profile/SettingsPage.dart';
import '../profile/NotificationsPage1.dart';
import '../profile/HelpPage.dart';
import 'ProfilePage.dart';
import 'CalendarPage.dart';
import 'MessagesPage.dart';
import '../profile/FavorisPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GlobalController _globalController = GlobalController.to;
  String userName = '';
  String userAvatar = '';

  @override
  void initState() {
    super.initState();
    initializeUser();
  }

  Future<void> initializeUser() async {
    _auth.currentUser!.uid;
    final DocumentSnapshot userDoc = await _db.collection('users').doc(_auth.currentUser!.uid).get();
    final UserModel user = UserModel.fromFirestore(userDoc);
    _globalController.setCurrentUser(user);
    setState(() {
      isLoading = false;
      userName = user.username;
      userAvatar = user.profilePicture ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading) {
      return const Scaffold(
        body: Center(
            child: CircularProgressIndicator()
        )
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              child: CircleAvatar(
                backgroundImage: userAvatar.isEmpty ? const AssetImage('assets/images/image.png') : NetworkImage(userAvatar),
                radius: 25,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Salut,",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavorisPage()),
              );
              // Ajouter la logique pour les favoris
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsPage1()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.help, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barre de recherche principale
              TextField(
                decoration: InputDecoration(
                  hintText: "Rechercher",
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Barre de recherche fine indépendante
              Container(
                height: 2,
                color: Colors.grey.shade300,
                margin: EdgeInsets.symmetric(vertical: 8),
              ),
              SizedBox(height: 20),
              // Section des options principales
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OptionCard(
                    icon: Icons.calendar_today,
                    text: "Prendre un rendez-vous",
                    color: Colors.blue.shade400,
                    height: 120, // Hauteur augmentée
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AppointmentPage()),
                      );
                    },
                  ),
                  OptionCard(
                    icon: Icons.location_on,
                    text: "Localiser une pharmacie",
                    color: Color(0xFFFBCFB2),
                    height: 120, // Hauteur augmentée
                  ),
                ],
              ),
              SizedBox(height: 20),
              OptionCard(
                icon: Icons.home,
                text: "Réserver un logement",
                color: Colors.teal.shade50,
                isFullWidth: true,
                height: 120, // Hauteur augmentée
              ),
              SizedBox(height: 30),
              // Section des rendez-vous
              Text(
                "Rendez-vous ultérieurs",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              AppointmentCard(), // Carte de téléconsultation Dr. Rim Maala
              SizedBox(height: 20),
              AppointmentCard2(), // Carte de téléconsultation Dr. Sami Fourti
              SizedBox(height: 20),
            ],
          ),
        ),
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



// Le reste du code reste inchangé pour OptionCard, AppointmentCard, etc.


class OptionCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final bool isFullWidth;
  final double height;
  final VoidCallback? onTap; // Ajoutez un callback pour le clic

  OptionCard({
    required this.icon,
    required this.text,
    required this.color,
    this.isFullWidth = false,
    this.height = 100,
    this.onTap, // Callback optionnel
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Utilisation du callback
      child: Container(
        width: isFullWidth ? double.infinity : MediaQuery.of(context).size.width * 0.45,
        height: height,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/doctor1.webp'),
                radius: 40,
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Dr. Rim Maala",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Généraliste",
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  Text(
                    "Jeudi, 14 novembre 12h30",
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            child: Text("Rejoindre l'appel",style: TextStyle(fontSize: 14, color: Colors.white),),
            style:
            ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppointmentCard2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/doctor2.jpg'),
                radius: 40,
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Dr. Sami Fourti",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Cardiologue",
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  Text(
                    "Lundi, 18 novembre 15h00",
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            child: Text("Rejoindre l'appel",style: TextStyle(fontSize: 14, color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


