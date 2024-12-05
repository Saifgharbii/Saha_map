import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saha_map/main.dart';
import 'package:saha_map/models/models.dart';
import '../profile/FavorisPage.dart';
import '../profile/HelpPage.dart';
import '../profile/SettingsPage.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalController _globalController = GlobalController.to;

  @override
  void initState() {
    super.initState();
    log(
      "ProfilePage"
      "initState"
      "Current user: ${_globalController.currentUser}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text(
          "Mon Profil",
          style: TextStyle(color: Colors.teal),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Section de l'image et du nom
            CircleAvatar(
              radius: 50,
              backgroundImage: (_globalController.currentUser.value?.profilePicture == null) ?
                const AssetImage("assets/images/F1.jpg") :
              NetworkImage(_globalController.currentUser.value?.profilePicture ?? ""),
            ),
            SizedBox(height: 10),
            Text(
              _globalController.currentUser.value?.username ?? "Amal Madhi",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Liste des options
            Expanded(
              child: ListView(
                children: [
                  _buildProfileOption(
                    context,
                    icon: Icons.person,
                    title: "Profil",
                    onTap: () {
                      // Action pour "Profil"
                    },
                  ),
                  _buildProfileOption(
                    context,
                    icon: Icons.favorite,
                    title: "Favoris",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FavorisPage()),
                      );// Action pour "Favoris"
                    },
                  ),
                  _buildProfileOption(
                    context,
                    icon: Icons.payment,
                    title: "Payment",
                    onTap: () {
                      // Action pour "Payment"
                    },
                  ),
                  _buildProfileOption(
                    context,
                    icon: Icons.lock,
                    title: "Politique De Confidentialité",
                    onTap: () {
                      // Action pour "Politique De Confidentialité"
                    },
                  ),
                  _buildProfileOption(
                    context,
                    icon: Icons.settings,
                    title: "Paramètres",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsPage()),
                      );// Action pour "Paramètres"
                    },
                  ),
                  _buildProfileOption(
                    context,
                    icon: Icons.help,
                    title: "Aide",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HelpPage()),
                      );// Action pour "Aide"
                    },
                  ),
                ],
              ),
            ),

            // Bouton de déconnexion
            TextButton(
              onPressed: () {
                _showLogoutConfirmation(context);
              },
              child: Text(
                "Déconnexion",
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget pour une option de profil
  Widget _buildProfileOption(BuildContext context,
      {required IconData icon, required String title, VoidCallback? onTap}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue.shade100,
        child: Icon(icon, color: Colors.blue),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 16),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  // Affichage de la boîte de confirmation de déconnexion
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Déconnexion"),
          content: Text("Êtes-vous sûr de vouloir vous déconnecter ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _auth.signOut();
                navigator?.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false);
              },
              child: Text("Oui"),
            ),
          ],
        );
      },
    );
  }
}
