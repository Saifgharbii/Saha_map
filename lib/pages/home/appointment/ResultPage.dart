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



class ResultPage extends StatelessWidget {
  final String selectedServiceProviderType;
  final GovernorateModel governorate;
  final Specialties speciality;

  final GlobalController globalController = Get.find();


  ResultPage({
    required this.selectedServiceProviderType,
    required this.governorate,
    required this.speciality,
  });


  @override
  Widget build(BuildContext context) {
    // List<ServiceProviderModel> serviceProvidersList = globalController.service_providers.value;
    // List<DoctorModel> doctorsList = globalController.doctors.value;
    List<DoctorWorksAtServiceProvider>  doctorWorksAtServiceProviderList = globalController.doctorWorksAtServiceProviders.value;

    final List<DoctorWorksAtServiceProvider> filtred_doctorWorksAtServiceProviderList = [] ;
    for (var docSer in doctorWorksAtServiceProviderList) {
      if (docSer.doctor.speciality == speciality &&
        docSer.serviceProvider.type == selectedServiceProviderType &&
        docSer.serviceProvider.governorate == governorate   ) {
          filtred_doctorWorksAtServiceProviderList.add(docSer);
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        title: Text(
          governorate.governorate.name,
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
                initialCenter: filtred_doctorWorksAtServiceProviderList.isNotEmpty
                    ? governorate.latlng : governorateMap["Tunis"]!.latlng, // Centre par défaut : Tunis
                initialZoom: 12.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: filtred_doctorWorksAtServiceProviderList.map((docSer) {
                    return Marker(
                      width: 80.0,
                      height: 80.0,
                      point:
                          LatLng(docSer.serviceProvider.latitude, docSer.serviceProvider.longitude),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(docSer.serviceProvider.name),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Adresse : ${'address nth'}",
                                  ),
                                  SizedBox(height: 10),
                                  const Text("Médecins disponibles :"),
                                  ...filtred_doctorWorksAtServiceProviderList.map<Widget>((docSer) => ListTile(
                                            leading: CircleAvatar(
                                              backgroundImage:
                                                  AssetImage(docSer.doctor.user.profilePicture!),
                                            ),
                                            title: Text(docSer.doctor.user.username),
                                            subtitle:
                                                Text(docSer.doctor.speciality.name),
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
              itemCount: filtred_doctorWorksAtServiceProviderList.length,
              itemBuilder: (context, index) {
                final docSer = filtred_doctorWorksAtServiceProviderList[index];
                return ListTile(
                  leading: Icon(Icons.medical_services,
                      color: Colors.teal, size: 30),
                  title: Text(
                    docSer.serviceProvider.name, //to be verified
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('ADDRESS NTHHH'),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 16,
                  ),
                  onTap: () {
                    if (selectedServiceProviderType == 'CLINIC') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClinicInfoPage(
                            serviceProvider : docSer.serviceProvider,
                            // name: location['name'],
                            // address: location['address'],
                            // latitude: location['latitude'],
                            // longitude: location['longitude'],
                            // description: location['description'],
                            // imagepath: location['imagepath'],
                            // avispatient: location['avispatient'],
                          ),
                        ),
                      );
                    } else if (selectedServiceProviderType == 'CABINET') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorInfoPage(
                            docSer: docSer
                            // name: location['name'],
                            // speciality: speciality,
                            // address: location['address'],
                            // latitude: location['latitude'],
                            // longitude: location['longitude'],
                            // description: location['description'],
                            // imagepath: location['imagepath'],
                            // avispatient: location['avispatient'],
                            // doctorAvailableTimesByDate:
                            //     location['doctorAvailableTimesByDate'],
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
