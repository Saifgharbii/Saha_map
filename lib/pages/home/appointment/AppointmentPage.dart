
import 'package:flutter/material.dart';
import 'package:saha_map/models/models.dart';
import '../CalendarPage.dart';
import '../MessagesPage.dart';
import 'ResultPage.dart';
import '../../profile/SettingsPage.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({Key? key}) : super(key: key);

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  // Use nullable types and initialize as null
  String? _selectedServiceProviderType;
  GovernorateModel? _selectedGovernorate;
  Specialties? _selectedSpeciality;

  // Consider making these static or moving to a separate configuration file
  static const List<String> _governorates = [
    "Tunis", "Ariana", "Ben_Arous", "Manouba", "Nabeul", "Bizerte", 
    "Beja", "Jendouba", "Zaghouan", "Kairouan", "Sousse", "Monastir", 
    "Mahdia", "Sfax", "Gabes", "Mednine", "Tataouine", "Kebili", 
    "Tozeur", "Gafsa", "Kasserine", "Sidi_Bouzid", "Siliana", "Le_Kef"
  ];

  static final List<Map<String, dynamic>> _specialities = [
    {
      "label": "Rheumatologie",
      "icon": Icons.medical_services,
      "specialty": Specialties.RHEUMATOLOGY
    },
    {
      "label": "Cardiologie", 
      "icon": Icons.favorite, 
      "specialty": Specialties.CARDIOLOGY
    },
    {
      "label": "Dermatologie", 
      "icon": Icons.spa, 
      "specialty": Specialties.DERMATOLOGY
    },
    {
      "label": "Endocrinologie", 
      "icon": Icons.health_and_safety, 
      "specialty": Specialties.ENDOCRINOLOGY
    },
    {
      "label": "Gastro-entérologie", 
      "icon": Icons.lunch_dining, 
      "specialty": Specialties.GASTROENTEROLOGY
    },
    {
      "label": "Médecine générale", 
      "icon": Icons.healing, 
      "specialty": Specialties.FAMILY_MEDICINE
    },
    {
      "label": "Pédiatrie", 
      "icon": Icons.child_friendly, 
      "specialty": Specialties.PEDIATRICS
    },
    {
      "label": "Ophtalmologie", 
      "icon": Icons.visibility, 
      "specialty": Specialties.OPHTHALMOLOGY
    },
    {
      "label": "Psychiatrie", 
      "icon": Icons.psychology, 
      "specialty": Specialties.PSYCHIATRY
    }
  ];

  void _validateAndNavigate() {
    if (_selectedServiceProviderType == null) {
      _showErrorSnackBar("Veuillez sélectionner un type de service");
      return;
    }

    if (_selectedGovernorate == null) {
      _showErrorSnackBar("Veuillez sélectionner un gouvernorat");
      return;
    }

    if (_selectedServiceProviderType == "CABINET" && _selectedSpeciality == null) {
      _showErrorSnackBar("Veuillez sélectionner une spécialité");
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          selectedServiceProviderType: _selectedServiceProviderType!,
          selectedGovernorate: _selectedGovernorate!,
          selectedSpeciality: _selectedServiceProviderType == "CABINET" 
            ? _selectedSpeciality! // Force unwrap only for CABINET
            : null,
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        title: const Text(
          "Prendre un rendez-vous",
          style: TextStyle(
            color: Colors.teal,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            const SizedBox(height: 30),
            const Text(
              "Sélectionner",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildServiceProviderTypeSelection(),
            const SizedBox(height: 30),
            _buildGovernorateDropdown(),
            if (_selectedServiceProviderType == "CABINET") ...[
              const SizedBox(height: 30),
              _buildSpecialitiesGrid(),
            ],
            const SizedBox(height: 20),
            _buildSearchButton(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeaderSection() {
    return Center(
      child: Column(
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 75,
          ),
          const SizedBox(height: 5),
          const Text(
            "Votre santé, Notre priorité!",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceProviderTypeSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SelectOptionCard(
          icon: Icons.local_hospital,
          label: "Clinique",
          isActive: _selectedServiceProviderType == "CLINIC",
          onPressed: () => setState(() => _selectedServiceProviderType = "CLINIC"),
        ),
        SelectOptionCard(
          icon: Icons.medical_services,
          label: "Cabinet",
          isActive: _selectedServiceProviderType == "CABINET",
          onPressed: () => setState(() => _selectedServiceProviderType = "CABINET"),
        ),
      ],
    );
  }

  Widget _buildGovernorateDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quelle ville ou quel gouvernorat ?",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            filled: true,
            fillColor: _selectedGovernorate == null
                ? Colors.grey.shade300
                : Colors.teal.shade100,
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
          onChanged: (value) => setState(() {
            _selectedGovernorate = governorateMap[value]!;
          }),
        ),
      ],
    );
  }

  Widget _buildSpecialitiesGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Spécialités",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
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
              isActive: _selectedSpeciality == speciality["specialty"],
              onPressed: () => setState(
                () => _selectedSpeciality = speciality["specialty"],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _validateAndNavigate,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: const Text(
          "Rechercher",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
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
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Calendrier",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Messages",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Paramètres",
          ),
        ],
      ),
    );
  }
}

// The SelectOptionCard and SpecialityCard classes remain the same as in the original code
class SelectOptionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  const SelectOptionCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onPressed,
  }) : super(key: key);

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
            Icon(
              icon,
              size: 40,
              color: isActive ? Colors.teal.shade600 : Colors.blue,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
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

  const SpecialityCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onPressed,
  }) : super(key: key);

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
            Icon(
              icon,
              size: 40,
              color: isActive ? Colors.teal.shade600 : Colors.blue,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}