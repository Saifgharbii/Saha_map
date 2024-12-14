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
import 'pharmacy_locator_page.dart';
import 'HousingLocatorPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  GlobalController globalController = GlobalController.to;
  late List<AppointmentModel> listOfAppointments;
  late List<String> appointmentDetails = [];

  String userName = '';
  String userAvatar = '';

  @override
  void initState() {
    super.initState();
    initializeUser();
  }

  Future<void> initializeUser() async {
    try {
      // Check if current user is authenticated
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

      // Fetch user document
      final DocumentSnapshot userDoc =
          await _db.collection('users').doc(currentUser.uid).get();

      // Convert Firestore document to UserModel
      final UserModel user = UserModel.fromFirestore(userDoc);

      // Set current user in GlobalController
      globalController.setCurrentUser(user);

      // Update state with user information
      setState(() {
        userName = user.username;
        userAvatar = user.profilePicture ?? "";
      });

      // Fetch all data (including appointments) from GlobalController
      await globalController.fetchAllData();

      // Fetch scheduled appointments
      await fetchScheduledAppointments();

      // Mark loading as complete
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user information: $e')),
      );
    }
  }

  Future<void> fetchScheduledAppointments() async {
    try {
      // Access appointments from GlobalController
      listOfAppointments = globalController.appointments;

      // Filter scheduled appointments for the current user
      final scheduledAppointments = listOfAppointments.where((appointment) {
        return appointment.patient.user.id == _auth.currentUser!.uid &&
            appointment.status == AppointmentStatus.SCHEDULED;
      }).toList();

      // Log appointment details
      //
      // Update the appointment details list for display
      appointmentDetails.clear(); // Clear any previous details
      if (scheduledAppointments.isEmpty) {
        appointmentDetails.add('No scheduled appointments for this user.');
      } else {
        for (var appointment in scheduledAppointments) {
          appointmentDetails.add(
              'Appointment with Dr. ${appointment.doctor.user.username} at ${appointment.appointmentHour}');
        }
      }
    } catch (e) {
      print('Error fetching scheduled appointments: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load appointments')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
                backgroundImage: userAvatar.isEmpty
                    ? const AssetImage('assets/images/image.png')
                    : NetworkImage(userAvatar),
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
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavorisPage()),
              );
              // Ajouter la logique pour les favoris
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsPage1()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.help, color: Colors.black),
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
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Barre de recherche fine indépendante
              Container(
                height: 2,
                color: Colors.grey.shade300,
                margin: const EdgeInsets.symmetric(vertical: 8),
              ),
              const SizedBox(height: 20),
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
                        MaterialPageRoute(
                            builder: (context) => AppointmentPage()),
                      );
                    },
                  ),
                  OptionCard(
                    icon: Icons.location_on,
                    text: "Localiser une pharmacie",
                    color: const Color(0xFFFBCFB2),
                    height: 120,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PharmacyLocatorPage()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              OptionCard(
                icon: Icons.home,
                text: "Réserver un logement",
                color: Colors.teal.shade50,
                isFullWidth: true,
                height: 120, // Hauteur augmentée
                  onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HousingLocatorPage()),
                      );
                    },
              ),
              const SizedBox(height: 30),
              // Section des rendez-vous
              const Text(
                "Rendez-vous ultérieurs",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Display appointments in a ListView
              if (appointmentDetails.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: appointmentDetails.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(appointmentDetails[index]),
                      ),
                    );
                  },
                )
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
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today), label: "Agenda"),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat), label: "Messagerie"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Paramètres"),
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

  const OptionCard({
    super.key,
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
        width: isFullWidth
            ? double.infinity
            : MediaQuery.of(context).size.width * 0.45,
        height: height,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
