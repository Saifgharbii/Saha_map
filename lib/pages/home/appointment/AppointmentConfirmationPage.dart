import 'package:flutter/material.dart';

class AppointmentConfirmationPage extends StatelessWidget {
  final String doctorName;
  final DateTime selectedDate;
  final String selectedTime;
  final String problemDescription;

  AppointmentConfirmationPage({
    required this.doctorName,
    required this.selectedDate,
    required this.selectedTime,
    required this.problemDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmation du Rendez-vous', style: TextStyle(color: Colors.teal)),
        backgroundColor: Colors.grey.shade50,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.teal),
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
                    Text('Rendez-vous avec $doctorName', style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(height: 10),
                    Text('Date: ${selectedDate.toLocal()}'),
                    SizedBox(height: 10),
                    Text('Heure: $selectedTime'),
                    SizedBox(height: 10),
                    Text('Problème: $problemDescription'),
                    SizedBox(height: 20),
                    Text('Demande enregistrée', style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold)),
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
