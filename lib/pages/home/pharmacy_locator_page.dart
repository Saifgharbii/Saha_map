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
    {'lat': 36.8065, 'lng': 10.1815, 'name': 'Pharmacie Ahmed', 'phone': '98-456-789', 'hours': '8:00 - 20:00', 'address': 'Rue Tunis Centre'},
    {'lat': 36.8120, 'lng': 10.1860, 'name': 'Pharmacie  ElYassamine', 'phone': '98-654-321', 'hours': '9:00 - 18:00', 'address': 'Avenue de la Liberté'},
    {'lat': 36.8040, 'lng': 10.1770, 'name': 'Pharmacie Sirine', 'phone': '54-321-987', 'hours': '10:00 - 19:00', 'address': 'Rue de la République'},
    {'lat': 36.8150, 'lng': 10.1900, 'name': 'Pharmacie Narjess', 'phone': '21-456-789', 'hours': '8:30 - 20:00', 'address': 'Avenue Bourguiba'},
    {'lat': 36.8200, 'lng': 10.2000, 'name': 'Pharmacie Amal', 'phone': '95-432-987', 'hours': '18:00 - 8:00', 'address': 'Rue de la Gare'},
    {'lat': 36.8090, 'lng': 10.1750, 'name': 'Pharmacie El wiem', 'phone': '90-765-432', 'hours': '8:00 - 18:00', 'address': 'Avenue Mohamed V'},
  ],
  'Mahdia': [
    {'lat': 35.5018, 'lng': 11.6245, 'name': 'Pharmacie Rdifi', 'phone': '98-654-321', 'hours': '9:00 - 17:00', 'address': 'Rue de la Corniche'},
    {'lat': 35.5000, 'lng': 11.6300, 'name': 'Pharmacie Chameri', 'phone': '23-456-789', 'hours': '8:00 - 20:00', 'address': 'Avenue Habib Bourguiba'},
    {'lat': 35.5100, 'lng': 11.6400, 'name': 'Pharmacie Yassmine', 'phone': '54-321-987', 'hours': '10:00 - 19:00', 'address': 'Rue des Palmiers'},
    {'lat': 35.4950, 'lng': 11.6200, 'name': 'Pharmacie Habib', 'phone': '21-654-987', 'hours': '9:00 - 20:00', 'address': 'Boulevard du Port'},
    {'lat': 35.5050, 'lng': 11.6250, 'name': 'Pharmacie Mahdia 5', 'phone': '95-432-123', 'hours': '8:30 - 19:30', 'address': 'Rue des Dunes'},
    {'lat': 35.4980, 'lng': 11.6330, 'name': 'Pharmacie Mahdia 6', 'phone': '43-210-987', 'hours': '10:00 - 18:00', 'address': 'Avenue de la Médina'},
  ],
  'Nabeul': [
    {'lat': 36.4665, 'lng': 10.7389, 'name': 'Pharmacie Nabeul 1', 'phone': '54-321-987', 'hours': '10:00 - 18:00', 'address': 'Rue de l’Indépendance'},
    {'lat': 36.4600, 'lng': 10.7400, 'name': 'Pharmacie Nabeul 2', 'phone': '21-654-987', 'hours': '8:00 - 20:00', 'address': 'Avenue Hédi Chaker'},
    {'lat': 36.4700, 'lng': 10.7450, 'name': 'Pharmacie Nabeul 3', 'phone': '98-654-321', 'hours': '9:00 - 19:00', 'address': 'Rue des Roses'},
    {'lat': 36.4750, 'lng': 10.7480, 'name': 'Pharmacie Nabeul 4', 'phone': '44-555-666', 'hours': '8:30 - 18:30', 'address': 'Avenue Mohamed Ali'},
    {'lat': 36.4600, 'lng': 10.7350, 'name': 'Pharmacie Nabeul 5', 'phone': '77-888-999', 'hours': '9:00 - 19:00', 'address': 'Rue de la Mer'},
    {'lat': 36.4500, 'lng': 10.7405, 'name': 'Pharmacie Nabeul 6', 'phone': '21-222-333', 'hours': '8:00 - 18:00', 'address': 'Boulevard des Fleurs'},
  ],
  'Sfax': [
    {'lat': 34.7400, 'lng': 10.7619, 'name': 'Pharmacie Sfax 1', 'phone': '21-222-333', 'hours': '8:00 - 20:00', 'address': 'Avenue Farhat Hached'},
    {'lat': 34.7450, 'lng': 10.7650, 'name': 'Pharmacie Sfax 2', 'phone': '54-555-666', 'hours': '9:00 - 19:00', 'address': 'Rue El Matar'},
    {'lat': 34.7550, 'lng': 10.7700, 'name': 'Pharmacie Sfax 3', 'phone': '55-666-777', 'hours': '8:00 - 20:00', 'address': 'Boulevard de l’Habib Bourguiba'},
    {'lat': 34.7350, 'lng': 10.7500, 'name': 'Pharmacie Sfax 4', 'phone': '96-777-888', 'hours': '8:30 - 19:30', 'address': 'Rue du Marché'},
    {'lat': 34.7400, 'lng': 10.7550, 'name': 'Pharmacie Sfax 5', 'phone': '97-888-999', 'hours': '9:00 - 18:00', 'address': 'Avenue de la Liberté'},
    {'lat': 34.7250, 'lng': 10.7400, 'name': 'Pharmacie Sfax 6', 'phone': '98-999-000', 'hours': '8:00 - 18:00', 'address': 'Rue Sidi Mansour'},
  ],
  'Sousse': [
    {'lat': 35.8250, 'lng': 10.6369, 'name': 'Pharmacie Sousse 1', 'phone': '77-888-999', 'hours': '8:00 - 20:00', 'address': 'Avenue Mohamed V'},
    {'lat': 35.8255, 'lng': 10.6400, 'name': 'Pharmacie Sousse 2', 'phone': '33-444-555', 'hours': '9:00 - 18:00', 'address': 'Rue Habib Bourguiba'},
    {'lat': 35.8240, 'lng': 10.6350, 'name': 'Pharmacie Sousse 3', 'phone': '22-333-444', 'hours': '10:00 - 19:00', 'address': 'Boulevard de la Médina'},
    {'lat': 35.8200, 'lng': 10.6300, 'name': 'Pharmacie Sousse 4', 'phone': '21-222-333', 'hours': '8:30 - 20:00', 'address': 'Rue de la Plage'},
    {'lat': 35.8300, 'lng': 10.6400, 'name': 'Pharmacie Sousse 5', 'phone': '94-555-666', 'hours': '9:00 - 19:00', 'address': 'Avenue du Golf'},
    {'lat': 35.8150, 'lng': 10.6250, 'name': 'Pharmacie Sousse 6', 'phone': '55-666-777', 'hours': '8:00 - 19:00', 'address': 'Rue El Ksar'},
  ],
  'Bizerte': [
    {'lat': 37.2762, 'lng': 9.8739, 'name': 'Pharmacie Bizerte 1', 'phone': '33-444-555', 'hours': '9:00 - 17:00', 'address': 'Rue de l’Indépendance'},
    {'lat': 37.2700, 'lng': 9.8700, 'name': 'Pharmacie Bizerte 2', 'phone': '22-333-444', 'hours': '8:00 - 20:00', 'address': 'Avenue de la Liberté'},
    {'lat': 37.2800, 'lng': 9.8800, 'name': 'Pharmacie Bizerte 3', 'phone': '91-222-333', 'hours': '9:00 - 19:00', 'address': 'Rue de la Gare'},
    {'lat': 37.2750, 'lng': 9.8850, 'name': 'Pharmacie Bizerte 4', 'phone': '44-555-666', 'hours': '8:30 - 18:30', 'address': 'Boulevard Habib Bourguiba'},
    {'lat': 37.2720, 'lng': 9.8760, 'name': 'Pharmacie Bizerte 5', 'phone': '55-666-777', 'hours': '9:00 - 18:00', 'address': 'Avenue de la République'},
    {'lat': 37.2705, 'lng': 9.8795, 'name': 'Pharmacie Bizerte 6', 'phone': '96-777-888', 'hours': '8:00 - 18:00', 'address': 'Rue du Port'},
  ],
};



  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  // Fonction de recherche pour changer la position de la carte
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
  } else if (query.toLowerCase() == 'sfax') {
    setState(() {
      userPosition = LatLng(34.7400, 10.7619); // Position de Sfax
    });
    _mapController.move(userPosition, 13.0);
  } else if (query.toLowerCase() == 'sousse') {
    setState(() {
      userPosition = LatLng(35.8250, 10.6369); // Position de Sousse
    });
    _mapController.move(userPosition, 13.0);
  } else if (query.toLowerCase() == 'bizerte') {
    setState(() {
      userPosition = LatLng(37.2762, 9.8739); // Position de Bizerte
    });
    _mapController.move(userPosition, 13.0);
  } else if (query.toLowerCase() == 'gabès') {
    setState(() {
      userPosition = LatLng(33.8833, 10.0989); // Position de Gabès
    });
    _mapController.move(userPosition, 13.0);
  } else if (query.toLowerCase() == 'kairouan') {
    setState(() {
      userPosition = LatLng(35.6783, 9.8720); // Position de Kairouan
    });
    _mapController.move(userPosition, 13.0);
  } else {
    setState(() {
      userPosition = LatLng(36.8065, 10.1815); // Position par défaut
    });
    _mapController.move(userPosition, 13.0);
  }
}



 List<Marker> _fetchPharmacies() {
  List<Marker> markers = [];

  // Récupérer toutes les pharmacies disponibles en fonction de la ville actuelle
  List<Map<String, dynamic>> pharmacies = pharmaciesByCity.entries
      .firstWhere((entry) => userPosition.latitude == entry.value[0]['lat'])
      .value;

  for (var pharmacy in pharmacies) {
    markers.add(
      Marker(
        point: LatLng(pharmacy['lat'], pharmacy['lng']),
        width: 40.0,
        height: 40.0,
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
                  address: pharmacy['address'], // Ajouter l'adresse ici
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

  return markers;
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
                // Affichage des marqueurs des pharmacies
                MarkerLayer(
                  markers: _fetchPharmacies(),
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
  final String address;

  const PharmacyDetailPage({
    Key? key,
    required this.name,
    required this.phone,
    required this.hours,
    required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          name,
          style: const TextStyle(color: Colors.teal),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.teal.shade100,
                    child: Icon(
                      Icons.local_pharmacy,
                      size: 40,
                      color: Colors.teal,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                InfoRow(label: "Téléphone", value: phone, icon: Icons.phone),
                InfoRow(label: "Horaires", value: hours, icon: Icons.access_time),
                InfoRow(label: "Adresse", value: address, icon: Icons.location_on),
                const Spacer(),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const InfoRow({
    Key? key,
    required this.label,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "$label : $value",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
