import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PharmacyLocatorPage extends StatefulWidget {
  @override
  _PharmacyLocatorPageState createState() => _PharmacyLocatorPageState();
}

class _PharmacyLocatorPageState extends State<PharmacyLocatorPage> {
  bool _isPharmaciesVisible = false;
  final TextEditingController _searchController = TextEditingController();
  late MapController _mapController;

  // Position initiale de la carte sur Tunis
  LatLng userPosition = LatLng(36.8065, 10.1815); // Position de Tunis

  // Liste des pharmacies avec des positions et informations
  Map<String, List<Map<String, dynamic>>> pharmaciesByCity = {
    'Tunis': [
      {'lat': 36.8065, 'lng': 10.1815, 'name': 'Pharmacie Tunis 1', 'phone': '123-456-789', 'hours': '8:00 - 20:00'},
      {'lat': 36.8120, 'lng': 10.1860, 'name': 'Pharmacie Tunis 2', 'phone': '987-654-321', 'hours': '9:00 - 18:00'},
      {'lat': 36.8040, 'lng': 10.1770, 'name': 'Pharmacie Tunis 3', 'phone': '654-321-987', 'hours': '10:00 - 19:00'},
    ],
    'Mahdia': [
      {'lat': 35.5018, 'lng': 11.6245, 'name': 'Pharmacie Mahdia 1', 'phone': '987-654-321', 'hours': '9:00 - 17:00'},
      {'lat': 35.5000, 'lng': 11.6300, 'name': 'Pharmacie Mahdia 2', 'phone': '123-456-789', 'hours': '8:00 - 20:00'},
    ],
    'Nabeul': [
      {'lat': 36.4665, 'lng': 10.7389, 'name': 'Pharmacie Nabeul 1', 'phone': '654-321-987', 'hours': '10:00 - 18:00'},
      {'lat': 36.4600, 'lng': 10.7400, 'name': 'Pharmacie Nabeul 2', 'phone': '321-654-987', 'hours': '8:00 - 20:00'},
      {'lat': 36.4700, 'lng': 10.7450, 'name': 'Pharmacie Nabeul 3', 'phone': '987-654-321', 'hours': '9:00 - 19:00'},
    ],
  };

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  // Fonction de recherche pour changer la position de la carte
  void _searchLocation(String query) {
    if (query.toLowerCase() == 'mahdia') {
      setState(() {
        userPosition = LatLng(35.5018, 11.6245); // Position de Mahdia
      });
      _mapController.move(userPosition, 13.0);
    } else if (query.toLowerCase() == 'nabeul') {
      setState(() {
        userPosition = LatLng(36.4665, 10.7389); // Position de Nabeul
      });
      _mapController.move(userPosition, 13.0);
    } else if (query.toLowerCase() == 'tunis') {
      setState(() {
        userPosition = LatLng(36.8065, 10.1815); // Position de Tunis
      });
      _mapController.move(userPosition, 13.0);
    } else {
      setState(() {
        userPosition = LatLng(36.8065, 10.1815); // Position par défaut
      });
      _mapController.move(userPosition, 13.0);
    }
  }

  // Fonction pour obtenir toutes les pharmacies d'une ville
  List<Widget> _fetchPharmacies() {
    List<Widget> pharmacyIcons = [];
    List<Map<String, dynamic>> pharmacies = pharmaciesByCity[userPosition.latitude == 36.8065 ? 'Tunis' : 'Mahdia'] ?? [];

    for (var pharmacy in pharmacies) {
      pharmacyIcons.add(
        Positioned(
          top: 180.0, // Position fictive pour les icônes
          left: 180.0, // Position fictive pour les icônes
          child: GestureDetector(
            onTap: () {
              // Navigation vers la page de détails de la pharmacie
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PharmacyDetailPage(
                    name: pharmacy['name'],
                    phone: pharmacy['phone'],
                    hours: pharmacy['hours'],
                  ),
                ),
              );
            },
            child: const Icon(
              Icons.local_pharmacy,
              color: Colors.blue,
              size: 40.0,
            ),
          ),
        ),
      );
    }
    return pharmacyIcons;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Localiser une pharmacie',
          style: TextStyle(color: Colors.teal),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              onSubmitted: _searchLocation, // Rechercher au moment où l'utilisateur soumet
              decoration: InputDecoration(
                hintText: "Rechercher une ville ",
                hintStyle: TextStyle(color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: const Icon(Icons.search, color: Colors.grey),
              ),
            ),
          ),
          // Carte avec Stack pour positionner les icônes des pharmacies
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              children: [
                // Affichage des tuiles de carte
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.sa7a_map',
                ),
                // Stack pour les icônes des pharmacies
                Builder(
                  builder: (context) {
                    return Stack(
                      children: [
                        // Icône de la position de l'utilisateur visible seulement avant confirmation
                        if (!_isPharmaciesVisible)
                          Positioned(
                            top: 180.0, // Position fictive de l'utilisateur
                            left: 180.0, // Position fictive de l'utilisateur
                            child: Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 40.0,
                            ),
                          ),
                        // Icônes des pharmacies (apparaissent après confirmation)
                        if (_isPharmaciesVisible) ..._fetchPharmacies(),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          // Partie formulaire de confirmation
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 5.0),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Action de confirmation : afficher les pharmacies autour de l'utilisateur
                    setState(() {
                      _isPharmaciesVisible = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Center(
                    child: Text("Confirmer localisation", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Page de détails de la pharmacie
class PharmacyDetailPage extends StatelessWidget {
  final String name;
  final String phone;
  final String hours;

  PharmacyDetailPage({required this.name, required this.phone, required this.hours});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails de la Pharmacie"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                subtitle: Text(phone),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Horaires : $hours", style: TextStyle(color: Colors.grey[600])),
                    const SizedBox(height: 10),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
