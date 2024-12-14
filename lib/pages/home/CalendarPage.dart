// import 'package:flutter/material.dart';

// import 'HomePage.dart';
// import 'MessagesPage.dart';
// import '../profile/SettingsPage.dart';

// class CalendarPage extends StatefulWidget {
//   const CalendarPage({super.key});

//   @override
//   _CalendarPageState createState() => _CalendarPageState();
// }

// class _CalendarPageState extends State<CalendarPage> {
//   String selectedTab = "Ultérieur";

//   final Map<String, List<Map<String, String>>> appointments = {
//     "Complété": [
//       {
//         "name": "Dr. Narjess Hadj Mohamed",
//         "description": "Cardiologie - Spécialiste du cœur",
//         "image": "assets/images/doctor7.jpg",
//       },
//       {
//         "name": "Dr. Sirine Charrada",
//         "description": "Dermatologie - Santé de la peau",
//         "image": "assets/images/doctor3.jpg",
//       },
//     ],
//     "Ultérieur": [
//       {
//         "name": "Dr. Rim Maala ",
//         "description": "Psychiatrie",
//         "image": "assets/images/doctor1.webp",
//         "date": "14/11/2024",
//         "time": "12:30",
//       },
//       {
//         "name": "Dr. Sami Fourti",
//         "description": "Cardiologie",
//         "image": "assets/images/doctor2.jpg",
//         "date": "18/11/2024",
//         "time": "15:00",
//       },
//     ],
//     "Annulé": [
//       {
//         "name": "Dr. Saif Gharbi",
//         "description": "Dermatologie - Santé de la peau",
//         "image": "assets/images/doctor5.jpg",
//       },
//     ],
//   };

//   int currentIndex = 1; // Indice de l'onglet sélectionné dans le BottomNavigationBar

//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, String>> currentAppointments =
//         appointments[selectedTab] ?? [];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Tous Les Rendez-Vous",
//           style: TextStyle(color: Colors.teal),
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.teal),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildCategoryTab("Complété"),
//                 _buildCategoryTab("Ultérieur"),
//                 _buildCategoryTab("Annulé"),
//               ],
//             ),
//           ),
//           const SizedBox(height: 10),
//           Expanded(
//             child: ListView.builder(
//               itemCount: currentAppointments.length,
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               itemBuilder: (context, index) {
//                 final appointment = currentAppointments[index];
//                 return _buildAppointmentCard(
//                   doctorName: appointment["name"]!,
//                   doctorDescription: appointment["description"]!,
//                   doctorImage: appointment["image"]!,
//                   type: selectedTab,
//                   date: appointment["date"],
//                   time: appointment["time"],
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: currentIndex,
//         elevation: 0,
//         backgroundColor: Colors.white,
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.black54,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
//           BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Agenda"),
//           BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Messagerie"),
//           BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
//         ],
//         onTap: (index) {
//           setState(() {
//             currentIndex = index;
//           });
//           switch (index) {
//             case 0:
//               _navigateToPage(context, const HomePage());
//               break;
//             case 1:
//             // Rester sur la page actuelle
//               break;
//             case 2:
//               _navigateToPage(context, MessagesPage());
//               break;
//             case 3:
//               _navigateToPage(context, SettingsPage());
//               break;
//           }
//         },
//       ),
//     );
//   }

//   // Fonction pour naviguer vers une page
//   void _navigateToPage(BuildContext context, Widget page) {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => page),
//     );
//   }

//   Widget _buildCategoryTab(String title) {
//     final bool isSelected = selectedTab == title;

//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedTab = title;
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.blue : Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: Colors.blue),
//         ),
//         child: Text(
//           title,
//           style: TextStyle(
//             color: isSelected ? Colors.white : Colors.blue,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAppointmentCard({
//     required String doctorName,
//     required String doctorDescription,
//     required String doctorImage,
//     required String type,
//     String? date,
//     String? time,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16.0),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.blue.shade50,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.shade200,
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 30,
//                 backgroundImage: AssetImage(doctorImage),
//               ),
//               const SizedBox(width: 16),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     doctorName,
//                     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     doctorDescription,
//                     style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
//                   ),
//                   if (date != null && time != null) ...[
//                     const SizedBox(height: 8),
//                     Text(
//                       "Date : $date, Heure : $time",
//                       style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
//                     ),
//                   ]
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: _buildActionButtons(type),
//           ),
//         ],
//       ),
//     );
//   }

//   List<Widget> _buildActionButtons(String type) {
//     if (type == "Complété") {
//       return [
//         _buildButton("Voir Détails", Colors.teal),
//         _buildButton("Ajouter Avis", Colors.blue),
//       ];
//     } else if (type == "Ultérieur") {
//       return [
//         _buildButton("Voir Détails", Colors.teal),
//         _buildButton("Annuler", Colors.blue),
//       ];
//     } else if (type == "Annulé") {
//       return [
//         _buildButton("Voir Détails", Colors.red),
//       ];
//     } else {
//       return [];
//     }
//   }

//   Widget _buildButton(String text, Color color) {
//     return ElevatedButton(
//       onPressed: () {
//         // Logique associée
//       },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: color,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//       child: Text(text, style: TextStyle(color: Colors.white)),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'HomePage.dart';
// import 'MessagesPage.dart';
// import '../profile/SettingsPage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:saha_map/models/models.dart';

// class CalendarPage extends StatefulWidget {
//   const CalendarPage({super.key});

//   @override
//   _CalendarPageState createState() => _CalendarPageState();
// }

// class _CalendarPageState extends State<CalendarPage> {
//   String selectedTab = "Ultérieur"; // Default to "Scheduled"
//   bool isLoading = true;
//   String errorMessage = '';
//   int currentIndex = 1;
//   final FirebaseFirestore _db = FirebaseFirestore.instance;

//   late GlobalController _globalController;
//   late List<AppointmentModel> listOfAppointments;
   
//   late List<String> appointmentDetails = [];

//   @override
//   void initState() {

//     super.initState();
//      initializeUser();
//     Firebase.initializeApp(); // Ensure Firebase is initialized
//     _globalController = GlobalController.to;
//     fetchAppointmentsByStatus("SCHEDULED"); // Default to SCHEDULED
//   }
// Future<void> initializeUser() async {
//     try {
//       // Check if current user is authenticated
//       final currentUser = _auth.currentUser;
//       if (currentUser == null) {
//         throw Exception('No authenticated user found');
//       }

//       // Fetch user document
//       final DocumentSnapshot userDoc =
//           await _db.collection('users').doc(currentUser.uid).get();

//       // Convert Firestore document to UserModel
//       final UserModel user = UserModel.fromFirestore(userDoc);

//       // Set current user in GlobalController
//       _globalController.setCurrentUser(user);

      
    
//       // Fetch scheduled appointments
//       await fetchAppointmentsByStatus();

//       // Mark loading as complete
//       setState(() {
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load user information: $e')),
//       );
//     }
//   }
//   // Fetch appointments from Firebase based on selected status
//   Future<void> fetchAppointmentsByStatus(String status) async {
//     setState(() {
//       isLoading = true;
//       errorMessage = '';
//     });

//     try {
//       // Assuming _globalController is populated or fetched from context
//       listOfAppointments = _globalController.appointments.value;

//       // Filter scheduled appointments for the current user
//       final appointments = listOfAppointments.where((appointment) {
//         return appointment.status == status &&  appointment.patient.user.id == _auth.currentUser!.uid )
//             appointment.status == AppointmentStatus.SCHEDULED;
//       }).toList();

//       setState(() {
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//         errorMessage = 'Failed to load appointments';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Tous Les Rendez-Vous",
//           style: TextStyle(color: Colors.teal),
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.teal),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildCategoryTab("Complété", "DONE"),
//                 _buildCategoryTab("Ultérieur", "SCHEDULED"),
//                 _buildCategoryTab("Annulé", "CANCELLED"),
//               ],
//             ),
//           ),
//           const SizedBox(height: 10),
//           isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : errorMessage.isNotEmpty
//                   ? Center(child: Text(errorMessage))
//                   : Expanded(
//                       child: ListView.builder(
//                         itemCount: listOfAppointments.length, // Use the correct list
//                         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                         itemBuilder: (context, index) {
//                           // Build the appointment card for each appointment
//                           var appointment = listOfAppointments[index];
//                           return _buildAppointmentCard(
//                             doctorName: appointment.doctor.user.username,
          
//                             doctorImage: appointment.doctor.user.profilePicture,
//                             date: appointment.appointmentDate,
//                             time: appointment.appointmentHour,
//                           );
//                         },
//                       ),
//                     ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: currentIndex,
//         elevation: 0,
//         backgroundColor: Colors.white,
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.black54,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
//           BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Agenda"),
//           BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Messagerie"),
//           BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
//         ],
//         onTap: (index) {
//           setState(() {
//             currentIndex = index;
//           });
//           switch (index) {
//             case 0:
//               _navigateToPage(context, const HomePage());
//               break;
//             case 1:
//               // Stay on the current page
//               break;
//             case 2:
//               _navigateToPage(context, MessagesPage());
//               break;
//             case 3:
//               _navigateToPage(context, SettingsPage());
//               break;
//           }
//         },
//       ),
//     );
//   }

//   // Function for navigating to a page
//   void _navigateToPage(BuildContext context, Widget page) {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => page),
//     );
//   }

//   // Function to build each category tab
//   Widget _buildCategoryTab(String title, String status) {
//     final bool isSelected = selectedTab == title;

//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedTab = title;
//         });
//         fetchAppointmentsByStatus(status); // Fetch data based on status
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.blue : Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: Colors.blue),
//         ),
//         child: Text(
//           title,
//           style: TextStyle(
//             color: isSelected ? Colors.white : Colors.blue,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }

//   // Function to build the appointment card
//   Widget _buildAppointmentCard({
//     required String doctorName,

//     required String? doctorImage,
//     DateTime? date,
//     DateTime? time,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16.0),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.blue.shade50,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.shade200,
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 30,
//                 backgroundImage: NetworkImage(
//                 doctorImage ?? 'https://via.placeholder.com/150', // Placeholder image
//               )),
//               const SizedBox(width: 16),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     doctorName,
//                     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
                 
//                   if (date != null && time != null) ...[
//                     const SizedBox(height: 8),
//                     Text(
//                       "Date : $date, Heure : $time",
//                       style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
//                     ),
//                   ]
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: _buildActionButtons(),
//           ),
//         ],
//       ),
//     );
//   }

//   // Action buttons for each appointment
//   List<Widget> _buildActionButtons() {
//     return [
//       _buildButton("Voir Détails", Colors.teal),
//       _buildButton("Annuler", Colors.blue),
//     ];
//   }

//   // Button widget to handle actions
//   Widget _buildButton(String text, Color color) {
//     return ElevatedButton(
//       onPressed: () {
//         // Logic for handling button press
//       },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: color,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//       child: Text(text, style: TextStyle(color: Colors.white)),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'HomePage.dart';
import 'MessagesPage.dart';
import '../profile/SettingsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saha_map/models/models.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  String selectedTab = "Ultérieur"; // Default to "Scheduled"
  bool isLoading = true;
  String errorMessage = '';
  int currentIndex = 1;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late GlobalController _globalController;
  late List<AppointmentModel> listOfAppointments = [];

  late List<String> appointmentDetails = [];

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp(); // Ensure Firebase is initialized
    _globalController = GlobalController.to;
    initializeUser();
  }

  Future<void> initializeUser() async {
    try {
      // Check if current user is authenticated
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

      // Fetch user document
      final DocumentSnapshot userDoc =
          await _db.collection('users').doc(currentUser.uid).get();

      // Convert Firestore document to UserModel
      final UserModel user = UserModel.fromFirestore(userDoc);

      // Set current user in GlobalController
      _globalController.setCurrentUser(user);

      // Fetch appointments for the default status
      await fetchAppointmentsByStatus(selectedTab); // Default to "Scheduled"

      // Mark loading as complete
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user information: $e')),
      );
    }
  }

  // Fetch appointments from Firebase based on selected status
  Future<void> fetchAppointmentsByStatus(String status) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // Assuming _globalController is populated or fetched from context
      listOfAppointments = _globalController.appointments.value;

      // Filter appointments for the current user based on status
      final appointments = listOfAppointments.where((appointment) {
        return appointment.status == status &&
            appointment.patient.user.id == _auth.currentUser!.uid;
      }).toList();

      setState(() {
        // If there are no appointments, show a message
        if (appointments.isEmpty) {
          errorMessage = 'No appointments found for the selected status';
        }

        isLoading = false;
        listOfAppointments = appointments;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load appointments';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tous Les Rendez-Vous",
          style: TextStyle(color: Colors.teal),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCategoryTab("Complété", "DONE"),
                _buildCategoryTab("Ultérieur", "SCHEDULED"),
                _buildCategoryTab("Annulé", "CANCELLED"),
              ],
            ),
          ),
          const SizedBox(height: 10),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
                  ? Center(child: Text(errorMessage))
                  : Expanded(
                      child: ListView.builder(
                        itemCount: listOfAppointments.length, // Use the filtered list
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemBuilder: (context, index) {
                          var appointment = listOfAppointments[index];
                          return _buildAppointmentCard(
                            doctorName: appointment.doctor.user.username,
                            doctorImage: appointment.doctor.user.profilePicture,
                            date: appointment.appointmentDate,
                            time: appointment.appointmentHour,
                          );
                        },
                      ),
                    ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        elevation: 0,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Agenda"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Messagerie"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
          switch (index) {
            case 0:
              _navigateToPage(context, const HomePage());
              break;
            case 1:
              // Stay on the current page
              break;
            case 2:
              _navigateToPage(context, MessagesPage());
              break;
            case 3:
              _navigateToPage(context, SettingsPage());
              break;
          }
        },
      ),
    );
  }

  // Function for navigating to a page
  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  // Function to build each category tab
  Widget _buildCategoryTab(String title, String status) {
    final bool isSelected = selectedTab == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = title;
        });
        fetchAppointmentsByStatus(status); // Fetch data based on status
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Function to build the appointment card
  Widget _buildAppointmentCard({
    required String doctorName,
    required String? doctorImage,
    DateTime? date,
    DateTime? time,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  doctorImage ?? 'https://via.placeholder.com/150', // Placeholder image
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctorName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  if (date != null && time != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      "Date : ${date.toLocal()}, Heure : ${time.toLocal()}",
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),
                  ]
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _buildActionButtons(),
          ),
        ],
      ),
    );
  }

  // Action buttons for each appointment
  List<Widget> _buildActionButtons() {
    return [
      _buildButton("Voir Détails", Colors.teal),
      _buildButton("Annuler", Colors.blue),
    ];
  }

  // Button widget to handle actions
  Widget _buildButton(String text, Color color) {
    return ElevatedButton(
      onPressed: () {
        // Logic for handling button press
      },
      style: ElevatedButton.styleFrom(backgroundColor: color),
      child: Text(text),
    );
  }
}
