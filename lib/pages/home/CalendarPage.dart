import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saha_map/pages/home/appointment/DoctorInfoPage.dart';
import 'HomePage.dart';
import 'MessagesPage.dart';
import '../profile/SettingsPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:saha_map/models/models.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AppointmentStatus selectedTab = AppointmentStatus.SCHEDULED; // Default to "Scheduled"
  bool isLoading = true;
  String errorMessage = '';
  int currentIndex = 1;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalController _globalController = GlobalController.to;
  List<AppointmentModel> listOfAppointments = [];

  List<String> appointmentDetails = [];

  @override
  void initState() {
    super.initState();
    listOfAppointments = _globalController.appointments;
    initializer();
  }

  Future<void> initializer() async {
    try {
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
  Future<void> fetchAppointmentsByStatus(AppointmentStatus status) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    try {
      // Assuming _globalController is populated or fetched from context
      listOfAppointments = _globalController.appointments;
      List<AppointmentModel> corespondingAppointments;
      if (_globalController.currentUser.value?.role == Role.DOCTOR) {
        corespondingAppointments = listOfAppointments.where((appointment) {
          return appointment.status == status &&
              appointment.doctor.user.id == _auth.currentUser!.uid;
        }).toList();
      }
      else{
        corespondingAppointments = listOfAppointments.where((appointment) {
          return appointment.status == status &&
              appointment.patient.user.id == _auth.currentUser!.uid;
        }).toList();
      }
      final appointments = corespondingAppointments;

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
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
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
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCategoryTab("Complété", AppointmentStatus.DONE),
                  const SizedBox(width: 10),
                  _buildCategoryTab("Ultérieur", AppointmentStatus.SCHEDULED),
                  const SizedBox(width: 10),
                  _buildCategoryTab("En attente", AppointmentStatus.ON_HOLD),
                  const SizedBox(width: 10),
                  _buildCategoryTab("Annulé", AppointmentStatus.CANCELED),
                ],
              ),
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
                            context: context,
                            selectedStatus:   selectedTab,
                            appointment : appointment,
                            doctorName: appointment.doctor.user.username,
                            doctorImage: appointment.doctor.user.profilePicture,
                            date: appointment.appointmentDate,
                            time: appointment.appointmentHour,
                            isDoctor: _globalController.currentUser.value?.role == Role.DOCTOR
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
              _navigateToPage(context, const MessagesPage());
              break;
            case 3:
              _navigateToPage(context, const SettingsPage());
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
  Widget _buildCategoryTab(String title, AppointmentStatus status) {
    final bool isSelected = selectedTab == status;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = status;
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
    required BuildContext context,
    required AppointmentStatus selectedStatus,
    required AppointmentModel appointment,
    required String doctorName,
    required String? doctorImage,
    DateTime? date,
    DateTime? time,
    required bool isDoctor
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
                  isDoctor ? appointment.patient.user.profilePicture ?? 'https://via.placeholder.com/150' :
                  appointment.doctor.user.profilePicture ?? 'https://via.placeholder.com/150'
                  , // Placeholder image
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isDoctor ? appointment.patient.user.username :appointment.doctor.user.username
                ,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  if (date != null ) ...[
                    const SizedBox(height: 8),
                    Text(
                      "Date : ${date.toIso8601String().split('T').first}, Heure : ${date.hour}:00",
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
            children: selectedStatus != AppointmentStatus.CANCELED ? _buildActionButtons(isDoctor, appointment,context) : [_buildActionButtons(isDoctor, appointment,context)[0]],
          ),
        ],
      ),
    );
  }

  // Action buttons for each appointment

  Future<void> _changeStateAppointment(bool isDoctor,AppointmentStatus status, AppointmentModel appointment) async {
    setState(() {
      isLoading = true;
    });

    QuerySnapshot querySnapshot = await _firestore.collection('appointments').get();
    final DocumentSnapshot doctorDoc = await _firestore.collection('doctors').doc(appointment.doctor.user.id).get();
    final DocumentSnapshot patientDoc = await _firestore.collection('patients').doc(appointment.patient.user.id).get();
    if (!(status == AppointmentStatus.SCHEDULED && !isDoctor)){
      for(var doc in querySnapshot.docs){
        final data = doc.data() as Map<String, dynamic>;
        if( data['doctor_ref'] == doctorDoc.reference &&
            data['patient_ref'] == patientDoc.reference &&
            (data['appointment_date'] as Timestamp).toDate() == appointment.appointmentDate ){
          await _firestore.collection('appointments').doc(doc.reference.id).set({'status': status.name}, SetOptions(merge: true));
          break;
        }
      }
    }
    await _globalController.fetchAppointments();
    await fetchAppointmentsByStatus(selectedTab);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> navigateToNext(BuildContext context, DoctorModel doctor) async{
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DoctorInfoPage(doctor: doctor)),
          );
      }
  List<Widget> _buildActionButtons(bool isDoctor, AppointmentModel appointment ,BuildContext context ) {
    return [
      _buildButton(isDoctor ? "Confirmer" : "Voir Détails", Colors.teal,isDoctor ? () =>  _changeStateAppointment(isDoctor,AppointmentStatus.SCHEDULED,appointment ) :() => navigateToNext(context,appointment.doctor) ),
      _buildButton("Annuler", Colors.blue,() => _changeStateAppointment(isDoctor,AppointmentStatus.CANCELED,appointment)),
    ];
  }

  // Button widget to handle actions
  Widget _buildButton(String text, Color color, VoidCallback fn) {
    return ElevatedButton(
      onPressed: () {
        fn();
      },
      style: ElevatedButton.styleFrom(backgroundColor: color),
      child: Text(text,
      style: const TextStyle(color: Colors.white,),
      ),

    );
  }
}
