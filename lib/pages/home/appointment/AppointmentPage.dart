import 'package:flutter/material.dart';

import '../CalendarPage.dart';
import '../MessagesPage.dart';
import 'ResultPage.dart';
import '../../profile/SettingsPage.dart';

class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  String selectedServiceProvider = ""; // Cabinet ou Clinique
  String selectedGovernorate = ""; // Gouvernorat
  String selectedSpeciality = ""; // Spécialité

  final List<String> _governorates = [
    "Tunis", "Ariana", "Ben Arous", "Manouba", "Nabeul",
    "Bizerte", "Beja", "Jendouba", "Zaghouan", "Kairouan",
    "Sousse", "Monastir", "Mahdia", "Sfax", "Gabes",
    "Mednine", "Tataouine", "Kebili", "Tozeur", "Gafsa",
    "Kasserine", "Sidi Bouzid", "Siliana", "Le Kef"
  ];

  final List<Map<String, dynamic>> _specialities = [
    {"label": "Anesthésiologie", "icon": Icons.local_hospital},
    {"label": "Cardiologie", "icon": Icons.favorite},
    {"label": "Dermatologie", "icon": Icons.spa},
    {"label": "Endocrinologie", "icon": Icons.medical_services},
    {"label": "Gastro-entérologie", "icon": Icons.lunch_dining},
    {"label": "Médecine interne", "icon": Icons.healing},
    {"label": "Pédiatrie", "icon": Icons.child_friendly},
    {"label": "Ophtalmologie", "icon": Icons.visibility},
    {"label": "Psychiatrie", "icon": Icons.psychology},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        title: Text(
          "Prendre un rendez-vous",
          style: TextStyle(color: Colors.teal, fontSize: 18, fontWeight: FontWeight.bold,),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 75,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Votre santé, Notre priorité!",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text("Sélectionner", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SelectOptionCard(
                  icon: Icons.local_hospital,
                  label: "Clinique",
                  isActive: selectedServiceProvider == "CLINIC",
                  onPressed: () => setState(() => selectedServiceProvider = "Clinique"),
                ),
                SelectOptionCard(
                  icon: Icons.medical_services,
                  label: "Cabinet",
                  isActive: selectedServiceProvider == "HOSPITAL",
                  onPressed: () => setState(() => selectedServiceProvider = "HOSPITAL"),
                ),
              ],
            ),
            SizedBox(height: 30),
    Text("Quelle ville ou quel gouvernorat ?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    SizedBox(height: 10),
    DropdownButtonFormField<String>(
    decoration: InputDecoration(
    filled: true,
    fillColor: selectedGovernorate.isEmpty ? Colors.grey.shade300 : Colors.teal.shade100,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide.none,
    ),
    ),
    hint: Text("Sélectionnez un gouvernorat"),
    items: _governorates.map((String value) {
    return DropdownMenuItem<String>(
    value: value,
    child: Text(value),
    );
    }).toList(),
    onChanged: (value) => setState(() {
    selectedGovernorate = value!;
    }),
    ),
            SizedBox(height: 30),
            Text("Spécialités", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _specialities.length,
              itemBuilder: (context, index) {
                final speciality = _specialities[index];
                return SpecialityCard(
                  icon: speciality["icon"],
                  label: speciality["label"],
                  isActive: selectedSpeciality == speciality["label"],
                  onPressed: () => setState(() => selectedSpeciality = speciality["label"]),
                );
              },
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (selectedServiceProvider.isEmpty || selectedGovernorate.isEmpty || selectedSpeciality.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Veuillez remplir tous les champs !")),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultPage(
                          option: selectedServiceProvider,
                          governorate: selectedGovernorate,
                          speciality: selectedSpeciality,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                child: Text(
                  "Rechercher",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
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
    break;
    case 1:
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CalendarPage()),
    );
    break;
    case 2:
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MessagesPage()),
    );
    break;
    case 3:
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

class SelectOptionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  SelectOptionCard({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive ? Colors.teal.shade200 : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: isActive ? Colors.teal.shade600 : Colors.blue),
            SizedBox(height: 10),
            Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class SpecialityCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  SpecialityCard({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? Colors.teal.shade200 : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: isActive ? Colors.teal.shade600 : Colors.blue),
            SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 14)),
          ],
        ),

        ),

    );
  }
}

