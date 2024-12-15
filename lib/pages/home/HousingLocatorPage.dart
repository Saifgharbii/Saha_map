import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math';

class HousingLocatorPage extends StatefulWidget {
  @override
  _HousingLocatorPageState createState() => _HousingLocatorPageState();
}

class _HousingLocatorPageState extends State<HousingLocatorPage> {
  final TextEditingController _searchController = TextEditingController();
  late MapController _mapController;

  // Position initiale de la carte sur Tunis
  LatLng userPosition = LatLng(36.8065, 10.1815); // Position de Tunis

  // Liste des logements et des cliniques avec des positions et informations
  Map<String, List<Map<String, dynamic>>> housingByCity = {
    'Tunis': [
      {'lat': 36.8090, 'lng': 10.1815, 'name': 'Clinique Tunis', 'type': 'clinic'},
      {'lat': 36.8070, 'lng': 10.1820, 'name': 'Maison El Manar', 'type': 'house', 'price': 150, 'rooms': 4},
      {'lat': 36.8100, 'lng': 10.1850, 'name': 'Appartement Lac 2', 'type': 'apartment', 'price': 120, 'rooms': 2},
      {'lat': 36.8120, 'lng': 10.1860, 'name': 'Appartement Belvédère', 'type': 'apartment', 'price': 110, 'rooms': 2},
      {'lat': 36.8200, 'lng': 10.1835, 'name': 'Maison El Menzah', 'type': 'house', 'price': 160, 'rooms': 5},
      {'lat': 36.8150, 'lng': 10.1880, 'name': 'Villa Tunis', 'type': 'house', 'price': 200, 'rooms': 6},
    ],
    'Sousse': [
      {'lat': 35.8256, 'lng': 10.6369, 'name': 'Clinique Sousse', 'type': 'clinic'},
      {'lat': 35.8270, 'lng': 10.6390, 'name': 'Villa Sousse', 'type': 'house', 'price': 180, 'rooms': 5},
      {'lat': 35.8290, 'lng': 10.6415, 'name': 'Appartement Sousse', 'type': 'apartment', 'price': 110, 'rooms': 3},
      {'lat': 35.8300, 'lng': 10.6425, 'name': 'Appartement El Kantaoui', 'type': 'apartment', 'price': 125, 'rooms': 4},
      {'lat': 35.8285, 'lng': 10.6375, 'name': 'Maison Sousse', 'type': 'house', 'price': 170, 'rooms': 6},
      {'lat': 35.8260, 'lng': 10.6350, 'name': 'Villa El Medeb', 'type': 'house', 'price': 220, 'rooms': 7},
    ],
    'Kairouan': [
  {'lat': 35.6755, 'lng': 10.0960, 'name': 'Clinique Kairouan', 'type': 'clinic'},
  {'lat': 35.6800, 'lng': 10.1000, 'name': 'Maison Kairouan', 'type': 'house', 'price': 140, 'rooms': 4},
],
'Nabeul': [
  {'lat': 36.4666, 'lng': 10.7382, 'name': 'Clinique Nabeul', 'type': 'clinic'},
  {'lat': 36.4600, 'lng': 10.7400, 'name': 'Villa Nabeul', 'type': 'house', 'price': 180, 'rooms': 5},
  {'lat': 36.4650, 'lng': 10.7350, 'name': 'Appartement Nabeul', 'type': 'apartment', 'price': 120, 'rooms': 2},
],
'Mahdia': [
  {'lat': 35.5075, 'lng': 11.0623, 'name': 'Clinique Mahdia', 'type': 'clinic'},
  {'lat': 35.5100, 'lng': 11.0650, 'name': 'Villa Mahdia', 'type': 'house', 'price': 200, 'rooms': 6},
  {'lat': 35.5150, 'lng': 11.0600, 'name': 'Appartement Mahdia', 'type': 'apartment', 'price': 130, 'rooms': 3},
],

    // Ajoutez d'autres villes et leurs logements ici
  };

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  // Fonction pour calculer la distance virtuelle entre deux points
  double _calculateDistance(LatLng point1, LatLng point2) {
    final double lat1 = point1.latitude;
    final double lon1 = point1.longitude;
    final double lat2 = point2.latitude;
    final double lon2 = point2.longitude;

    const double radius = 6371; // Rayon de la Terre en kilomètres

    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) *
        sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return radius * c; // Retourne la distance en kilomètres
  }

  // Convertir des degrés en radians
  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  // Fonction de recherche pour changer la position de la carte
  void _searchLocation(String query) {
    if (query.toLowerCase() == 'tunis') {
      setState(() {
        userPosition = LatLng(36.8065, 10.1815); // Position de Tunis
      });
      _mapController.move(userPosition, 13.0);
    } else if (query.toLowerCase() == 'sousse') {
      setState(() {
        userPosition = LatLng(35.8256, 10.6369); // Position de Sousse
      });
      _mapController.move(userPosition, 13.0);
    } else {
      setState(() {
        userPosition = LatLng(36.8065, 10.1815); // Position par défaut
      });
      _mapController.move(userPosition, 13.0);
    }
  }

  List<Marker> _fetchHousingMarkers() {
  List<Marker> markers = [];

  // Récupérer tous les logements disponibles en fonction de la ville actuelle
  List<Map<String, dynamic>> housing = housingByCity['Tunis']!;

  // Première passe pour ajouter des marqueurs
  for (var i = 0; i < housing.length; i++) {
    var place = housing[i];

    // Déterminer l'icône en fonction du type de logement
    IconData iconData;
    Color iconColor;
    double offsetX = 0;  // Décalage horizontal
    double offsetY = 0;  // Décalage vertical

    if (place['type'] == 'clinic') {
      iconData = Icons.local_hospital;  // Icône de clinique
      iconColor = Colors.blue;  // Couleur bleue pour la clinique
    } else if (place['type'] == 'house') {
      iconData = Icons.house;  // Icône de maison
      iconColor = Colors.green;  // Couleur verte pour la maison
      // Décalage pour les maisons
      offsetX = 0.002 * (i % 2 == 0 ? 1 : -1);  // Déplacement léger à gauche/droite
      offsetY = 0.002 * (i % 2 == 0 ? 1 : -1);  // Déplacement léger haut/bas
    } else if (place['type'] == 'apartment') {
      iconData = Icons.apartment;  // Icône d'appartement
      iconColor = Colors.orange;  // Couleur orange pour l'appartement
      // Décalage pour les appartements
      offsetX = 0.005 * (i % 2 == 0 ? -1 : 1);  // Déplacement léger à gauche/droite
      offsetY = 0.005 * (i % 2 == 0 ? -1 : 1);  // Déplacement léger haut/bas
    } else {
      iconData = Icons.location_on;  // Icône par défaut
      iconColor = Colors.grey;  // Couleur par défaut
    }

    // Calculer la nouvelle position du marqueur avec décalage
    LatLng adjustedPosition = LatLng(
      place['lat'] + offsetY,
      place['lng'] + offsetX,
    );

    markers.add(
      Marker(
        point: adjustedPosition,  // Position ajustée
        width: 40.0,
        height: 40.0,
        child: GestureDetector(
          onTap: () {
            // Afficher les détails du logement
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(place['name']),
                content: Text("Type: ${place['type']}\nPrix: \$${place['price']}\nChambres: ${place['rooms']}"),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Ajouter la logique de réservation ici
                      Navigator.pop(context);
                    },
                    child: Text('Réserver'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Annuler'),
                  ),
                ],
              ),
            );
          },
          child: Icon(
            iconData,
            color: iconColor,  // Appliquer la couleur de l'icône en fonction du type
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
          'Réserver un logement',
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
              onSubmitted: _searchLocation, // Recherche au moment de la soumission
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
          // Carte avec Stack pour positionner les icônes des logements et des cliniques
          Expanded(

            child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                      initialCenter:
                      userPosition,
                      initialZoom: 12.0,
                      ),
              children: [
                // Affichage des tuiles de carte
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                // Affichage des marqueurs des logements
                MarkerLayer(
                  markers: _fetchHousingMarkers(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
