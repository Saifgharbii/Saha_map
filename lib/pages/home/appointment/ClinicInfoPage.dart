import 'package:flutter/material.dart';
import 'package:saha_map/models/models.dart';
import 'package:url_launcher/url_launcher.dart';

import '../CalendarPage.dart';
import '../MessagesPage.dart';
import '../../profile/SettingsPage.dart';
import '../message.dart';
List<Map<String, dynamic>> favoriteDoctors = [];

class ClinicInfoPage extends StatelessWidget {
  final ServiceProviderModel serviceProvider ;
  // final String name;
  // final String description;
  // final String address;
  // final double latitude;
  // final double longitude;
  // final String imagepath;
  // final List<Map<String, String>> avispatient;

  ClinicInfoPage({
    required this.serviceProvider,
    // required this.description,
    // required this.address,
    // required this.latitude,
    // required this.longitude,
    // required this.imagepath,
    // required this.avispatient,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Infos Clinique", style: TextStyle(color: Colors.teal),),
        centerTitle: true,
        backgroundColor: Colors.grey[100],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Carte principale pour la clinique
              _buildClinicCard(context),
              const SizedBox(height: 16),
              // Section Profil
              _buildSectionTitle("Profil"),
              Text(
                serviceProvider.description,
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 16),
              // Avis des patients
              _buildSectionTitle("Avis des Patients"),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
      // Barre de navigation en bas
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

  // Carte principale de la clinique
  Widget _buildClinicCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image de la clinique
          Image.asset(
            serviceProvider.photo_url,
            height: 120,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 8),
          // Nom de la clinique
          Text(
            serviceProvider.name,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          // Adresse de la clinique
          Text(
            serviceProvider.governorate.governorate.name,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          // Boutons fonctionnels
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Action pour prendre contact avec la clinique
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: Text(
                  "Ajouter avis",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: Text(
                  "Voir sur la carte",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Bouton pour prendre rendez-vous
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MessageDetailsPage(name: '', avatar: '', messages: const [],)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            child: const Text("Contacter", style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }


  // Widget pour construire une section avec un titre
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }

  // Widget pour afficher les avis des patients

  // Widget _buildPatientReviews() {
  //   return Column(
  //     children: avispatient.map((review) {
  //       return Card(
  //         margin: EdgeInsets.symmetric(vertical: 8),
  //         child: ListTile(
  //           leading: CircleAvatar(
  //             backgroundImage: AssetImage(review['image']!),
  //           ),
  //           title: Text(review['name']!),
  //           subtitle: Text(review['review']!),
  //         ),
  //       );
  //     }).toList(),
  //   );
  // }
}
