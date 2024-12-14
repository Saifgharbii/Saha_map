import 'package:flutter/material.dart';
import 'package:saha_map/models/models.dart';

import '../CalendarPage.dart';
import '../HomePage.dart';
import '../MessagesPage.dart';
import '../../profile/SettingsPage.dart';
import 'choisiredate.dart';
import 'package:saha_map/globals.dart';
import 'package:provider/provider.dart';
import 'package:saha_map/FavoriteDoctorsModel.dart';

// Simulez la liste des médecins favoris
List<Map<String, String>> favoriteDoctors = [];
List<Map<String, List<String>>> randomValues = [
{
"fruits": ["apple", "banana", "cherry"],
"vegetables": ["carrot", "spinach", "broccoli"],
"drinks": ["water", "juice", "soda"],
}];

class DoctorInfoPage extends StatefulWidget {
  final DoctorModel docSer;
  // final String name;
  // final String speciality;
  // final String address;
  // final double latitude;
  // final double longitude;
  // final String description;
  // final String imagepath;
  // final List<Map<String, String>> avispatient;
  // final List<Map<String, List<String>>> doctorAvailableTimesByDate;

  const DoctorInfoPage({super.key,
    required this.docSer,
    // required this.name,
    // required this.speciality,
    // required this.address,
    // required this.latitude,
    // required this.longitude,
    // required this.description,
    // required this.imagepath,
    // required this.avispatient,
    // required this.doctorAvailableTimesByDate,
  });

  @override
  _DoctorInfoPageState createState() => _DoctorInfoPageState();
}

class _DoctorInfoPageState extends State<DoctorInfoPage> {
  bool isFavorite = false; // Variable pour gérer l'état du cœur
 

  @override
  void initState() {
    super.initState();
    // Vérifiez si le médecin est déjà dans les favoris au démarrage
    isFavorite = favoriteDoctors.any((doctor) => doctor['name'] == widget.docSer.user.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Infos Médecin",
          style: TextStyle(color: Colors.teal),
        ),
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
              _buildDoctorCard(context), // Carte principale
              const SizedBox(height: 16),
              _buildSectionTitle("Profil"),
              Text(
                widget.docSer.user.username,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 16),
              _buildSectionTitle("Avis des Patients"),
              _buildPatientReviews(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black54,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
              break;
            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CalendarPage()),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: "Agenda"),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context) {
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                      if (isFavorite) {
                        Provider.of<FavoriteDoctorsModel>(context, listen: false).addFavorite({
                          'name': widget.docSer.user.username,
                          'speciality': widget.docSer.speciality.name,
                          'imagepath': widget.docSer.user.profilePicture ?? 'https://www.refugee-action.org.uk/wp-content/uploads/2016/10/anonymous-user.png',
                        });
                      } else {
                         final doctorToRemove = Provider.of<FavoriteDoctorsModel>(context, listen: false)
      .favoriteDoctors
      .firstWhere((doctor) => doctor['name'] == widget.docSer.user.username, );

  if (doctorToRemove != null) {
    // Remove the found doctor
    Provider.of<FavoriteDoctorsModel>(context, listen: false).removeFavorite(doctorToRemove);
  }
                      }
                      // Debug: Affiche la liste des favoris dans la console
                      print("Liste des favoris : ${Provider.of<FavoriteDoctorsModel>(context, listen: false).favoriteDoctors}");
                    });

                    final snackBar = SnackBar(
                      content: Text(
                        isFavorite ? "Ajouté aux favoris" : "Retiré des favoris",
                      ),
                      duration: const Duration(seconds: 2),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(widget.docSer.user.profilePicture ?? 'https://www.refugee-action.org.uk/wp-content/uploads/2016/10/anonymous-user.png'),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.docSer.user.username,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.docSer.speciality.name,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Ajouter avis
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
                  // Contacter médecin
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: Text(
                  "Contacter",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChoisireDatePage(
                    doctorName: widget.docSer.user.username,
                    doctorAvailableTimesByDate: randomValues,
                  ),
                ),
              );
            },
            child: const Text(
              'Choisir une date',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

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

  Widget _buildPatientReviews() {
    return Column(
      // children: widget.avispatient.map((review) {
      //   return Card(
      //     margin: const EdgeInsets.symmetric(vertical: 8),
      //     child: ListTile(
      //       leading: CircleAvatar(
      //         backgroundImage: AssetImage(review['image']!),
      //       ),
      //       title: Text(review['name']!),
      //       subtitle: Text(review['review']!),
      //     ),
      //   );
      // }).toList(),
    );
  }
}
