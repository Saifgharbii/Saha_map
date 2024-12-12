import 'package:flutter/material.dart';
import 'package:saha_map/models/models.dart';

import '../CalendarPage.dart';
import '../MessagesPage.dart';
import 'ResultPage.dart';
import '../../profile/SettingsPage.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  String selectedServiceProviderType = ""; // Cabinet ou Clinique
  late GovernorateModel? selectedGovernorate ; // Gouvernorat
  Specialties? selectedSpeciality; // Spécialité

  final List<String> _governorates = [
    "Tunis", "Ariana", "Ben_Arous", "Manouba", "Nabeul",
    "Bizerte", "Beja", "Jendouba", "Zaghouan", "Kairouan",
    "Sousse", "Monastir", "Mahdia", "Sfax", "Gabes",
    "Mednine", "Tataouine", "Kebili", "Tozeur", "Gafsa",
    "Kasserine", "Sidi_Bouzid", "Siliana", "Le_Kef"
  ];

  final List<Map<String, dynamic>> _specialities = [
    {"label": "Anesthésiologie", "icon": Icons.medical_services, "specialty": Specialties.ANESTHESIOLOGY},
    {"label": "Cardiologie", "icon": Icons.favorite, "specialty": Specialties.CARDIOLOGY},
    {"label": "Dermatologie", "icon": Icons.spa, "specialty": Specialties.DERMATOLOGY},
    {"label": "Endocrinologie", "icon": Icons.health_and_safety, "specialty": Specialties.ENDOCRINOLOGY},
    {"label": "Gastro-entérologie", "icon": Icons.lunch_dining, "specialty": Specialties.GASTROENTEROLOGY},
    {"label": "Médecine interne", "icon": Icons.healing, "specialty": Specialties.GENERAL_PRACTICE},
    {"label": "Pédiatrie", "icon": Icons.child_friendly, "specialty": Specialties.PEDIATRICS},
    {"label": "Ophtalmologie", "icon": Icons.visibility, "specialty": Specialties.OPHTHALMOLOGY},
    {"label": "Psychiatrie", "icon": Icons.psychology, "specialty": Specialties.PSYCHIATRY}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        title: const Text(
          "Prendre un rendez-vous",
          style: TextStyle(color: Colors.teal, fontSize: 18, fontWeight: FontWeight.bold,),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
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
                  const SizedBox(height: 5),
                  const Text(
                    "Votre santé, Notre priorité!",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text("Sélectionner", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SelectOptionCard(
                  icon: Icons.local_hospital,
                  label: "Clinique",
                  isActive: selectedServiceProviderType == "CLINIC",
                  onPressed: () => setState(() => selectedServiceProviderType = "CLINIC"),
                ),
                SelectOptionCard(
                  icon: Icons.medical_services,
                  label: "Cabinet",
                  isActive: selectedServiceProviderType == "CABINET",
                  onPressed: () => setState(() => selectedServiceProviderType = "CABINET"),
                ),
              ],
            ),
            const SizedBox(height: 30),
    const Text("Quelle ville ou quel gouvernorat ?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    const SizedBox(height: 10),
    DropdownButtonFormField<String>(
    decoration: InputDecoration(
    filled: true,
    fillColor: selectedGovernorate == null? Colors.grey.shade300 : Colors.teal.shade100,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide.none,
    ),
    ),
    hint: const Text("Sélectionnez un gouvernorat"),
    items: _governorates.map((String value) {
    return DropdownMenuItem<String>(
    value: value,
    child: Text(value),
    );
    }).toList(),
    onChanged: (value) => setState(() {selectedGovernorate = governorateMap[value]!; }),
    ),
            const SizedBox(height: 30),
            const Text("Spécialités", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                  isActive: selectedSpeciality == speciality["specialty"],
                  onPressed: () => setState(() => selectedSpeciality = speciality["specialty"]),
                );
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (selectedServiceProviderType.isEmpty || selectedGovernorate == null || selectedSpeciality == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Veuillez remplir tous les champs !")),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultPage(
                          selectedServiceProviderType : selectedServiceProviderType,
                          governorate: selectedGovernorate!,
                          speciality: selectedSpeciality! ,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                child: const Text(
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
    MaterialPageRoute(builder: (context) => const CalendarPage()),
    );
    break;
    case 2:
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const MessagesPage()),
    );
    break;
    case 3:
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const SettingsPage()),
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
}

class SelectOptionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  const SelectOptionCard({super.key, 
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive ? Colors.teal.shade200 : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: isActive ? Colors.teal.shade600 : Colors.blue),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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

  const SpecialityCard({super.key, 
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
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
          ],
        ),

        ),

    );
  }
}

