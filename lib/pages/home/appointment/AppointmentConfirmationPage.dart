import 'package:flutter/material.dart';
import 'package:saha_map/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';

class AppointmentConfirmationPage extends StatefulWidget {
  final DoctorModel doctor;
  final DateTime selectedDate;
  final int selectedHour;
  final String problemDescription;

  const AppointmentConfirmationPage({super.key, 
    required this.doctor,
    required this.selectedDate,
    required this.selectedHour,
    required this.problemDescription,
  });
  @override
  _AppointmentConfirmationPage createState() => _AppointmentConfirmationPage();
}

class _AppointmentConfirmationPage extends State<AppointmentConfirmationPage> {
  final Faker _faker = Faker();
  GlobalController globalController = GlobalController.to;
  bool isLoading = true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addAppointment( ) async {
    try {
      UserModel currentUser = globalController.currentUser.value!;
      DateTime appointmentDate = DateTime(
          widget.selectedDate.year,
          widget.selectedDate.month,
          widget.selectedDate.day,
          widget.selectedHour);
      AppointmentModel? newAppointment;
      PatientModel patient = globalController.currentPatient.value!;


      newAppointment = AppointmentModel(patient: patient,
          doctor: widget.doctor,
          appointmentDate: appointmentDate,
          appointmentHour: appointmentDate,
          mode: AppointmentMode.ONLINE,
          status: AppointmentStatus.ON_HOLD);

      await _firestore.collection('appointments').add(await newAppointment.toFirestore());
      // Mark loading as complete
      setState(() {
        isLoading = false;
      });
    }
    catch(e){
      // Mark loading as complete
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    addAppointment();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
        appBar: AppBar(
        title: const Text('Confirmation du Rendez-vous', style: TextStyle(color: Colors.teal)),
        backgroundColor: Colors.grey.shade50,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Rendez-vous avec ${widget.doctor.user.username}', style: const TextStyle(color: Colors.blue,fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('Date: ${widget.selectedDate.toLocal()}'),
                    const SizedBox(height: 10),
                    Text('Heure: ${widget.selectedHour}'),
                    const SizedBox(height: 10),
                    Text('Problème: ${widget.problemDescription}'),
                    const SizedBox(height: 20),
                    const Text('Demande enregistrée', style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
