import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saha_map/main.dart';
import 'package:saha_map/models/models.dart';
import 'package:saha_map/pages/home/PaymentPage.dart';
import '../profile/FavorisPage.dart';
import '../profile/HelpPage.dart';
import '../profile/SettingsPage.dart';
import 'PolitiqueConfidentialitePage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

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
        title: const Text(
          "Mon Profil",
          style: TextStyle(color: Colors.teal),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
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
              backgroundImage:
                  (_globalController.currentUser.value?.profilePicture == null)
                      ? const AssetImage("assets/images/F1.jpg")
                      : NetworkImage(
                          _globalController.currentUser.value?.profilePicture ??
                              ""),
            ),
            const SizedBox(height: 10),
            Text(
              _globalController.currentUser.value?.username ?? "Amal Madhi",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

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
                      ); // Action pour "Favoris"
                    },
                  ),
                  _buildProfileOption(
                    context,
                    icon: Icons.payment,
                    title: "Payment",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PaymentPage()),
                      );// Action pour "Payment"
                    },
                  ),
                  _buildProfileOption(
                    context,
                    icon: Icons.lock,
                    title: "Politique De Confidentialité",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PolitiqueConfidentialitePage()),
                      );// Action pour "Payment"
                    
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
                      ); // Action pour "Paramètres"
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
                      ); // Action pour "Aide"
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
              child: const Text(
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
        style: const TextStyle(fontSize: 16),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  // Affichage de la boîte de confirmation de déconnexion
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Déconnexion"),
          content: const Text("Êtes-vous sûr de vouloir vous déconnecter ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fermer la boîte de dialogue
              },
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Fermer la boîte de dialogue
                _logout(); // Appeler la méthode de déconnexion
              },
              child: const Text("Oui"),
            ),
          ],
        );
      },
    );
  }

  void _logout() async {
    try {
      await _auth.signOut(); // Déconnexion de Firebase
      log("Utilisateur déconnecté avec succès.");

      // Rediriger vers l'écran de connexion
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    } catch (e) {
      log("Erreur lors de la déconnexion : $e");
      // Afficher un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Erreur lors de la déconnexion : ${e.toString()}")),
      );
    }
  }
}
