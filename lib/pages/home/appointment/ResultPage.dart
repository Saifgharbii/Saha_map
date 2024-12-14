// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:get/get.dart';

// import '../CalendarPage.dart';
// import 'ClinicInfoPage.dart';
// import 'DoctorInfoPage.dart';
// import '../MessagesPage.dart';
// import '../../profile/SettingsPage.dart';
// import '../../../models/models.dart';

// class ResultPage extends StatelessWidget {
//   final String selectedServiceProviderType;
//   final String selectedGovernorate;
//   final String selectedSpeciality;

//   ResultPage({
//     required this.selectedServiceProviderType,
//     required this.selectedGovernorate,
//     required this.selectedSpeciality,
//   });

//   //final GlobalController globalController = Get.find();

//   late GlobalController _globalController;
//   late List<DoctorModel> listOfDoctors;
//   late List<String> doctprDetails = [];

//  Future<void> fetchScheduledAppointments() async {
//     try {
//       // Access appointments from GlobalController
//       if selectedServiceProviderType=="CABINET"
//        listOfDoctors = _globalController.doctors.value;

//       // Filter scheduled appointments for the current user
//        final Doctors= listOfDoctors.where((doctor) {
//         return doctor.governorate == selectedGovernorate && doctor.speciality==selectedSpeciality
//        }).toList();

//        doctprDetails.clear(); // Clear any previous details
//         if (Doctors.isEmpty) {
//         doctprDetails.add('On n a pas de médecins dans ce gouverneurat. Nous sommes désolés.');
//        } else {
//         for (var doctor in listOfDoctors) {
//           doctprDetails.add(
//               'Le médecin Dr. ${doctor.user.username} a une expèrience de ${doctor.experienceYears}');
//         }
//       }
//     } catch (e) {
//       print('Error fetching list of doctors: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load doctors')),
//       );
//     }
//   }

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.grey.shade50,
//         title: Text(
//           governorate.governorate.name,
//           style: TextStyle(color: Colors.teal),
//         ),
//         iconTheme: const IconThemeData(color: Colors.teal),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             flex: 1,
//             child: FlutterMap(
//               options: MapOptions(
//                 initialCenter: filtred_doctorWorksAtServiceProviderList.isNotEmpty
//                     ? governorate.latlng : governorateMap["Tunis"]!.latlng, // Centre par défaut : Tunis
//                 initialZoom: 12.0,
//               ),
//               children: [
//                 TileLayer(
//                   urlTemplate:
//                       "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//                   subdomains: ['a', 'b', 'c'],
//                 ),
//                 MarkerLayer(
//                   markers: filtred_doctorWorksAtServiceProviderList.map((docSer) {
//                     return Marker(
//                       width: 80.0,
//                       height: 80.0,
//                       point:
//                           LatLng(docSer.serviceProvider.latitude, docSer.serviceProvider.longitude),
//                       child: GestureDetector(
//                         onTap: () {
//                           showDialog(
//                             context: context,
//                             builder: (context) => AlertDialog(
//                               title: Text(docSer.serviceProvider.name),
//                               content: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Text(
//                                     "Adresse : ${'address nth'}",
//                                   ),
//                                   SizedBox(height: 10),
//                                   const Text("Médecins disponibles :"),
//                                   ...filtred_doctorWorksAtServiceProviderList.map<Widget>((docSer) => ListTile(
//                                             leading: CircleAvatar(
//                                               backgroundImage:
//                                                   AssetImage(docSer.doctor.user.profilePicture!),
//                                             ),
//                                             title: Text(docSer.doctor.user.username),
//                                             subtitle:
//                                                 Text(docSer.doctor.speciality.name),
//                                           ))
//                                       .toList(),
//                                 ],
//                               ),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () => Navigator.pop(context),
//                                   child: const Text("Fermer"),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                         child: const Icon(
//                           Icons.location_on,
//                           color: Colors.red,
//                           size: 40.0,
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: ListView.builder(
//               itemCount: filtred_doctorWorksAtServiceProviderList.length,
//               itemBuilder: (context, index) {
//                 final docSer = filtred_doctorWorksAtServiceProviderList[index];
//                 return ListTile(
//                   leading: Icon(Icons.medical_services,
//                       color: Colors.teal, size: 30),
//                   title: Text(
//                     docSer.serviceProvider.name, //to be verified
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Text('ADDRESS NTHHH'),
//                   trailing: Icon(
//                     Icons.arrow_forward_ios,
//                     color: Colors.grey,
//                     size: 16,
//                   ),
//                   onTap: () {
//                     if (selectedServiceProviderType == 'CLINIC') {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ClinicInfoPage(
//                             serviceProvider : docSer.serviceProvider,
//                             // name: location['name'],
//                             // address: location['address'],
//                             // latitude: location['latitude'],
//                             // longitude: location['longitude'],
//                             // description: location['description'],
//                             // imagepath: location['imagepath'],
//                             // avispatient: location['avispatient'],
//                           ),
//                         ),
//                       );
//                     } else if (selectedServiceProviderType == 'CABINET') {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => DoctorInfoPage(
//                             docSer: docSer

//                           ),
//                         ),
//                       );
//                     }
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: Container(
//         color: Colors.blue.shade100,
//         child: BottomNavigationBar(
//           elevation: 0,
//           selectedItemColor: Colors.blue,
//           unselectedItemColor: Colors.black54,
//           onTap: (index) {
//             switch (index) {
//               case 0:
//                 break;
//               case 1:
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => CalendarPage()),
//                 );
//                 break;
//               case 2:
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => MessagesPage()),
//                 );
//                 break;
//               case 3:
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => SettingsPage()),
//                 );
//                 break;
//             }
//           },
//           items: [
//             BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
//             BottomNavigationBarItem(
//                 icon: Icon(Icons.calendar_today), label: "Agenda"),
//             BottomNavigationBarItem(
//                 icon: Icon(Icons.chat), label: "Messagerie"),
//             BottomNavigationBarItem(
//                 icon: Icon(Icons.settings), label: "Paramètres"),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../models/models.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';

// class ResultPage extends StatefulWidget {
//   final String selectedServiceProviderType;
//   final GovernorateModel selectedGovernorate;
//   final Specialties selectedSpeciality;

//   const ResultPage({
//     Key? key,
//     required this.selectedServiceProviderType,
//     required this.selectedGovernorate,
//     required this.selectedSpeciality,
//   }) : super(key: key);

//   @override
//   _ResultPageState createState() => _ResultPageState();
// }

// class _ResultPageState extends State<ResultPage> {
//   // Initialize GlobalController
//   final GlobalController _globalController = Get.find();

//   // Initialize lists
//   List<DoctorModel> listOfDoctors = [];
//   List<String> doctorDetails = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchScheduledAppointments();
//   }

//   Future<void> fetchScheduledAppointments() async {
//     try {
//       // Access appointments from GlobalController
//       if (widget.selectedServiceProviderType == "CABINET") {
//         listOfDoctors = _globalController.doctors.value;
//       }

//       // Filter doctors based on governorate and speciality
//       final filteredDoctors = listOfDoctors.where((doctor) {
//         return doctor.governorate == widget.selectedGovernorate &&
//                doctor.speciality == widget.selectedSpeciality;
//       }).toList();

//       // Clear previous details
//       setState(() {
//         doctorDetails.clear();

//         // Handle empty list case
//         if (filteredDoctors.isEmpty) {
//           doctorDetails.add('On n\'a pas de médecins dans ce gouvernorat. Nous sommes désolés.');
//         } else {
//           for (var doctor in filteredDoctors) {
//             doctorDetails.add(
//               'Le médecin Dr. ${doctor.user.username} a une expérience de ${doctor.experienceYears}'
//             );
//           }
//         }
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Erreur de chargement: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Résultats de recherche'),
//       ),
//       body: ListView.builder(
//         itemCount: doctorDetails.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(doctorDetails[index]),
//           );
//         },
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_map/flutter_map.dart'; // If you're using flutter_map
// import '../../../models/models.dart';
// import 'package:latlong2/latlong.dart';

// class ResultPage extends StatefulWidget {
//   final String selectedServiceProviderType;
//   final GovernorateModel selectedGovernorate;
//   final Specialties selectedSpeciality;

//   const ResultPage({
//     Key? key,
//     required this.selectedServiceProviderType,
//     required this.selectedGovernorate,
//     required this.selectedSpeciality,
//   }) : super(key: key);

//   @override
//   _ResultPageState createState() => _ResultPageState();
// }

// class _ResultPageState extends State<ResultPage> {
//   // Initialize GlobalController
//   final GlobalController _globalController = Get.find();

//   // Initialize lists
//   List<DoctorModel> listOfDoctors = [];
//   List<String> doctorDetails = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchScheduledAppointments();
//   }

//   Future<void> fetchScheduledAppointments() async {
//     try {
//       // Access appointments from GlobalController
//       if (widget.selectedServiceProviderType == "CABINET") {
//         listOfDoctors = _globalController.doctors.value;
//       }

//       // Filter doctors based on governorate and speciality
//       final filteredDoctors = listOfDoctors.where((doctor) {
//         return doctor.governorate == widget.selectedGovernorate &&
//             doctor.speciality == widget.selectedSpeciality;
//       }).toList();

//       // Clear previous details
//       setState(() {
//         doctorDetails.clear();

//         // Handle empty list case
//         if (filteredDoctors.isEmpty) {
//           doctorDetails.add(
//               'On n\'a pas de médecins dans ce gouvernorat. Nous sommes désolés.');
//         } else {
//           for (var doctor in filteredDoctors) {
//             doctorDetails.add(
//                 'Le médecin Dr. ${doctor.user.username} a une expérience de ${doctor.experienceYears}');
//           }
//         }
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Erreur de chargement: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final governorate = widget.selectedGovernorate;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Résultats de recherche'),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Carte interactive
//           Expanded(
//             flex: 2,
//             child: FlutterMap(
//               options: MapOptions(

//                 // center: LatLng(governorate.lat, governorate.long),
//                 // zoom: 12.0,
//               ),
//               children: [
//                 TileLayer(
//                   urlTemplate:
//                       "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//                   subdomains: ['a', 'b', 'c'],
//                 ),
//                 MarkerLayer(
//                   markers: listOfDoctors.map((doctor) {
//                     return Marker(
//                       width: 80.0,
//                       height: 80.0,
//                       point: LatLng(
//                         governorate.lat,
//                         governorate.long,
//                       ),
//                       child: GestureDetector(
//                         onTap: () {
//                           showDialog(
//                             context: context,
//                             builder: (context) => AlertDialog(
//                               title: Text('Dr. ${doctor.user.username}'),
//                               content: Text(
//                                 "Expérience : ${doctor.experienceYears} ans\n"
//                                 "Spécialité : ${doctor.speciality.name}",
//                               ),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () => Navigator.pop(context),
//                                   child: Text("Fermer"),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                         child: Icon(
//                           Icons.location_on,
//                           color: Colors.red,
//                           size: 40,
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ],
//             ),
//           ),
//           Divider(),
//           // Liste des détails des médecins
//           Expanded(
//             flex: 3,
//             child: doctorDetails.isNotEmpty
//                 ? ListView.builder(
//                     itemCount: doctorDetails.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(doctorDetails[index]),
//                         leading: Icon(Icons.person),
//                       );
//                     },
//                   )
//                 : Center(
//                     child: Text(
//                       'Aucun médecin trouvé.',
//                       style:
//                           TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_map/flutter_map.dart'; // If you're using flutter_map
// import '../../../models/models.dart';
// import 'package:latlong2/latlong.dart';
// import 'DoctorInfoPage.dart';  // Import the DoctorInfoPage here

// class ResultPage extends StatefulWidget {
//   final String selectedServiceProviderType;
//   final GovernorateModel selectedGovernorate;
//   final Specialties selectedSpeciality;

//   const ResultPage({
//     Key? key,
//     required this.selectedServiceProviderType,
//     required this.selectedGovernorate,
//     required this.selectedSpeciality,
//   }) : super(key: key);

//   @override
//   _ResultPageState createState() => _ResultPageState();
// }

// class _ResultPageState extends State<ResultPage> {
//   final GlobalController _globalController = Get.find();
//   List<DoctorModel> listOfDoctors = [];
//   List<String> doctorDetails = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchScheduledAppointments();
//   }

//   Future<void> fetchScheduledAppointments() async {
//     try {
//       if (widget.selectedServiceProviderType == "CABINET") {
//         listOfDoctors = _globalController.doctors.value;
//       }

//       final filteredDoctors = listOfDoctors.where((doctor) {
//         return doctor.governorate == widget.selectedGovernorate &&
//             doctor.speciality == widget.selectedSpeciality;
//       }).toList();

//       setState(() {
//         doctorDetails.clear();
//         if (filteredDoctors.isEmpty) {
//           doctorDetails.add(
//               'On n\'a pas de médecins dans ce gouvernorat. Nous sommes désolés.');
//         } else {
//           for (var doctor in filteredDoctors) {
//             doctorDetails.add(
//                 'Le médecin Dr. ${doctor.user.username} a une expérience de ${doctor.experienceYears}');
//           }
//         }
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Erreur de chargement: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final governorate = widget.selectedGovernorate;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Résultats de recherche'),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Interactive Map
//           Expanded(
//             flex: 2,
//             child: FlutterMap(
//               options: MapOptions(
//                 initialCenter: LatLng(governorate.lat, governorate.long),
//                 initialZoom: 12.0,
//               ),
//               children: [
//                 TileLayer(
//                   urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//                   subdomains: ['a', 'b', 'c'],
//                 ),
//                 MarkerLayer(
//                   markers: listOfDoctors.map((doctor) {
//                     return Marker(
//                       width: 80.0,
//                       height: 80.0,
//                       point: LatLng(governorate.lat, governorate.long),
//                       child: GestureDetector(
//                         onTap: () {
//                           showDialog(
//                             context: context,
//                             builder: (context) => AlertDialog(
//                               title: Text('Dr. ${doctor.user.username}'),
//                               content: Text(
//                                 "Expérience : ${doctor.experienceYears} ans\n"
//                                 "Spécialité : ${doctor.speciality.name}",
//                               ),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () => Navigator.pop(context),
//                                   child: Text("Fermer"),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                         child: Icon(
//                           Icons.location_on,
//                           color: Colors.red,
//                           size: 40,
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ],
//             ),
//           ),
//           Divider(),
//           // Doctor Details Section
//           Expanded(
//             flex: 3,
//             child: doctorDetails.isNotEmpty
//                 ? ListView.builder(
//                     itemCount: doctorDetails.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(doctorDetails[index]),
//                         leading: Icon(Icons.person),
//                       );
//                     },
//                   )
//                 : Center(
//                     child: Text(
//                       'Aucun médecin trouvé.',
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//           ),
//           // Doctor's professional message with a button
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               elevation: 5,
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Le Dr. spécialiste en ${widget.selectedSpeciality.name}, vous propose des consultations adaptées à vos besoins de santé.',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.blueAccent,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       'Prenez rendez-vous en ligne facilement avec ce médecin.',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey[700],
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: () {
//                         // Navigate to DoctorInfoPage
//                         // Navigator.push(
//                         //   context,
//                         //   MaterialPageRoute(
//                         //     builder: (context) => DoctorInfoPage(

//                         //     ),
//                         //   ),
//                         // );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blueAccent,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: Text(
//                         'Voir les Détails',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_map/flutter_map.dart'; // If you're using flutter_map
// import '../../../models/models.dart';
// import 'package:latlong2/latlong.dart';
// import 'DoctorInfoPage.dart';  // Import the DoctorInfoPage here

// class ResultPage extends StatefulWidget {
//   final String selectedServiceProviderType;
//   final GovernorateModel selectedGovernorate;
//   final Specialties selectedSpeciality;

//   const ResultPage({
//     Key? key,
//     required this.selectedServiceProviderType,
//     required this.selectedGovernorate,
//     required this.selectedSpeciality,
//   }) : super(key: key);

//   @override
//   _ResultPageState createState() => _ResultPageState();
// }

// class _ResultPageState extends State<ResultPage> {
//   final GlobalController _globalController = Get.find();
//   List<DoctorModel> listOfDoctors = [];
//   List<String> doctorDetails = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchScheduledAppointments();
//   }

//   Future<void> fetchScheduledAppointments() async {
//     try {
//       if (widget.selectedServiceProviderType == "CABINET") {
//         listOfDoctors = _globalController.doctors.value;
//       }

//       final filteredDoctors = listOfDoctors.where((doctor) {
//         return doctor.governorate == widget.selectedGovernorate &&
//             doctor.speciality == widget.selectedSpeciality;
//       }).toList();

//       setState(() {
//         doctorDetails.clear();
//         if (filteredDoctors.isEmpty) {
//           doctorDetails.add(
//               'On n\'a pas de médecins dans ce gouvernorat. Nous sommes désolés.');
//         } else {
//           for (var doctor in filteredDoctors) {
//             doctorDetails.add(
//                 'Le médecin Dr. ${doctor.user.username} a une expérience de ${doctor.experienceYears} ans dans le dommaine de ${doctor.speciality}.N hésitez pas de prendre un rendez-vous');
//           }
//         }
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Erreur de chargement: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final governorate = widget.selectedGovernorate;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Résultats de recherche'),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Combine map and doctor details into one section
//           Expanded(
//             flex: 1,
//             child: Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               elevation: 5,
//               child: Column(
//                 children: [
//                   // Interactive Map
//                   Expanded(
//                     flex: 2,
//                     child: FlutterMap(
//                       options: MapOptions(
//                         initialCenter: LatLng(governorate.lat, governorate.long),
//                         initialZoom: 12.0,
//                       ),
//                       children: [
//                         TileLayer(
//                           urlTemplate:
//                               "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//                           subdomains: ['a', 'b', 'c'],
//                         ),
//                         MarkerLayer(
//                           markers: listOfDoctors.map((doctor) {
//                             return Marker(
//                               width: 80.0,
//                               height: 80.0,
//                               point: LatLng(governorate.lat, governorate.long),
//                               child: GestureDetector(
//                                 onTap: () {
//                                   showDialog(
//                                     context: context,
//                                     builder: (context) => AlertDialog(
//                                       title: Text('Dr. ${doctor.user.username}'),
//                                       content: Text(
//                                         "Expérience : ${doctor.experienceYears} ans\n"
//                                         "Spécialité : ${doctor.speciality.name}",
//                                       ),
//                                       actions: [
//                                         TextButton(
//                                           onPressed: () => Navigator.pop(context),
//                                           child: Text("Fermer"),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 },
//                                 child: Icon(
//                                   Icons.location_on,
//                                   color: Colors.red,
//                                   size: 40,
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Divider(),
//                   // Doctor Details Section
//                   Expanded(
//                     flex: 1,
//                     child: doctorDetails.isNotEmpty
//                         ? ListView.builder(
//                             itemCount: doctorDetails.length,
//                             itemBuilder: (context, index) {
//                               return ListTile(
//                                 title: Text(doctorDetails[index]),
//                                 leading: Icon(Icons.person),
//                               );
//                             },
//                           )
//                         : Center(
//                             child: Text(
//                               'Aucun médecin trouvé.',
//                               style: TextStyle(
//                                   fontSize: 16, fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart'; // If you're using flutter_map
import '../../../models/models.dart';
import 'package:latlong2/latlong.dart';
import 'DoctorInfoPage.dart'; // Import the DoctorInfoPage here
import 'package:firebase_core/firebase_core.dart';
import '../../../firebase_options.dart';class ResultPage extends StatefulWidget {
  final String selectedServiceProviderType;
  final GovernorateModel selectedGovernorate;
  final Specialties selectedSpeciality;

  const ResultPage({
    Key? key,
    required this.selectedServiceProviderType,
    required this.selectedGovernorate,
    required this.selectedSpeciality,
  }) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  GlobalController globalController = GlobalController.to;
  List<DoctorModel> listOfDoctors = [];
  List<DoctorModel> filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    fetchScheduledAppointments();
  }

  Future<void> fetchScheduledAppointments() async {
    try {
      if (widget.selectedServiceProviderType == "CABINET") {
        listOfDoctors = globalController.doctors;
      }

      // Filter doctors based on governorate and speciality
      filteredDoctors = listOfDoctors.where((doctor) {
        return doctor.governorate == widget.selectedGovernorate &&
            doctor.speciality == widget.selectedSpeciality;
      }).toList();

      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de chargement: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final governorate = widget.selectedGovernorate;

    return Scaffold(
      appBar: AppBar(
        title: Text('Résultats de recherche'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Combine map and doctor details into one section
          Expanded(
            flex: 1,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              child: Column(
                children: [
                  // Interactive Map
                  Expanded(
                    flex: 2,
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(governorate.lat, governorate.long),
                        initialZoom: 12.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: ['a', 'b', 'c'],
                        ),
                        
                      ],
                    ),
                  ),
                  Divider(),
                  // Doctor List Section
                  Expanded(
                    flex: 1,
                    child: filteredDoctors.isNotEmpty
                        ? ListView.builder(
                            itemCount: filteredDoctors.length,
                            itemBuilder: (context, index) {
                              final doctor = filteredDoctors[index];
                              return ListTile(
                                leading: ClipOval(
                                  child: Image.network(
                                    doctor.user.profilePicture ??
                                        'https://via.placeholder.com/150',
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.error, size: 60);
                                    },
                                  ),
                                ),
                                title: Text(
                                  'Le médecin Dr. ${doctor.user.username}',
                                ),
                                subtitle: Text(
                                  'Cliquez pour plus de détails',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DoctorInfoPage(docSer: doctor),
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              'Aucun médecin trouvé.',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
