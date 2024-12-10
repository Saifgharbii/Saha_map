import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';

import '../CalendarPage.dart';
import 'ClinicInfoPage.dart';
import 'DoctorInfoPage.dart';
import '../MessagesPage.dart';
import '../../profile/SettingsPage.dart';
import '../../../models/models.dart';
import '../../../main.dart';



class ResultPage extends StatelessWidget {
  final String option;
  final String governorate;
  final String speciality;
  final GlobalController globalController = Get.find<GlobalController>();

  ResultPage({
    required this.option,
    required this.governorate,
    required this.speciality,
  });
  List<ServiceProviderModel> serviceProvidersList = globalController.service_providers.value;

  @override
  Widget build(BuildContext context) {
    // Filtrer les lieux en fonction des critères
    final filteredLocations = locations.where((location) {
      // Vérifier si la spécialité correspond dans specialitybydoctor
      bool matchesSpeciality = location['specialitybydoctor']
          .any((doctor) => doctor['speciality'] == speciality);
      bool matchesGovernorate =
          location['address'].toLowerCase().contains(governorate.toLowerCase());
      bool matchesOption = option == 'Clinique'
          ? location['name'].contains('Clinique')
          : location['name'].contains('Cabinet');
      return matchesSpeciality && matchesGovernorate && matchesOption;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        title: Text(
          governorate,
          style: TextStyle(color: Colors.teal),
        ),
        iconTheme: IconThemeData(color: Colors.teal),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: filteredLocations.isNotEmpty
                    ? LatLng(filteredLocations.first['latitude'],
                        filteredLocations.first['longitude'])
                    : LatLng(36.8065, 10.1815), // Centre par défaut : Tunis
                initialZoom: 12.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: filteredLocations.map((location) {
                    return Marker(
                      width: 80.0,
                      height: 80.0,
                      point:
                          LatLng(location['latitude'], location['longitude']),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(location['name']),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Adresse : ${location['address']}",
                                  ),
                                  SizedBox(height: 10),
                                  Text("Médecins disponibles :"),
                                  ...location['specialitybydoctor']
                                      .map<Widget>((doctor) => ListTile(
                                            leading: CircleAvatar(
                                              backgroundImage:
                                                  AssetImage(doctor['image']),
                                            ),
                                            title: Text(doctor['name']),
                                            subtitle:
                                                Text(doctor['speciality']),
                                          ))
                                      .toList(),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("Fermer"),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40.0,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: filteredLocations.length,
              itemBuilder: (context, index) {
                final location = filteredLocations[index];
                return ListTile(
                  leading: Icon(Icons.medical_services,
                      color: Colors.teal, size: 30),
                  title: Text(
                    location['name'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(location['address']),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 16,
                  ),
                  onTap: () {
                    if (option == 'Clinique') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClinicInfoPage(
                            name: location['name'],
                            address: location['address'],
                            latitude: location['latitude'],
                            longitude: location['longitude'],
                            description: location['description'],
                            imagepath: location['imagepath'],
                            avispatient: location['avispatient'],
                          ),
                        ),
                      );
                    } else if (option == 'Cabinet') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorInfoPage(
                            name: location['name'],
                            speciality: speciality,
                            address: location['address'],
                            latitude: location['latitude'],
                            longitude: location['longitude'],
                            description: location['description'],
                            imagepath: location['imagepath'],
                            avispatient: location['avispatient'],
                            doctorAvailableTimesByDate:
                                location['doctorAvailableTimesByDate'],
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
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
