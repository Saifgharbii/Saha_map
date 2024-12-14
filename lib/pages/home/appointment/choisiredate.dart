import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:saha_map/models/models.dart';
import 'package:table_calendar/table_calendar.dart';

import 'AppointmentConfirmationPage.dart';

// Page principale pour choisir une date
class ChoisireDatePage extends StatefulWidget {
  final DoctorModel doctor;

  const ChoisireDatePage({
    super.key,
    required this.doctor,
  });

  @override
  State<ChoisireDatePage> createState() => _ChoisireDatePageState(doctor: doctor);
}



class _ChoisireDatePageState extends State<ChoisireDatePage> {
  final DoctorModel doctor;

  _ChoisireDatePageState({required this.doctor});

  late DateTime _selectedDate;
  late AppointmentModel appointment ;
  late int? _selectedHour = null ;
  String _selectedGender = 'Masculin'; // Genre sélectionné
  String _problemDescription = ''; // Description du problème
  GlobalController globalController = GlobalController.to;
  late List<AppointmentModel> listOfAppointments = [];
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    fetchScheduledAppointments();
  }

  Future<void> fetchScheduledAppointments() async {
    try {
      // Filter scheduled appointments for the current user
      final scheduledAppointments = GlobalController.to.appointments.where((appointment) {
        return
          appointment.doctor.user.id == widget.doctor.user.id &&
            appointment.status == AppointmentStatus.SCHEDULED;
      }).toList();
      setState(() {
        listOfAppointments = scheduledAppointments;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching scheduled appointments: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load appointments')),
      );
      setState(() {
        listOfAppointments = [];
        isLoading = false;
      });    }
  }

  // Construction du sélecteur de date avec TableCalendar
  Widget buildDateSelector() {

    return TableCalendar(
      focusedDay: _selectedDate,
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      selectedDayPredicate: (day) {
        return isSameDay(day, _selectedDate);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDate = selectedDay;
        });
      },
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.blueAccent,
          shape: BoxShape.circle,
        ),
        weekendTextStyle: TextStyle(color: Colors.red),
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false, // Désactive le bouton de format (mois/semaines)
        titleCentered: true, // Centrer le titre du mois
      ),
    );
  }


  // Construction du sélecteur d'heures
  Widget buildTimeSelector() {
    // Liste des horaires de 8h à 17h
    List<String> allHours = [];
    for (int i = 8; i <= 17; i++) {
      allHours.add('$i:00');
    }
    List<int> not_availble_at =[] ;
    for (var appointment in listOfAppointments)  {
        if(appointment.appointmentDate.day == _selectedDate.day){
          not_availble_at.add(appointment.appointmentDate.hour);
        }
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: allHours.map((hour) {
        // Vérifier si l'heure est disponible
        final isNotAvailable = not_availble_at.contains(int.parse(hour.split(":")[0]));
        final isSelected = _selectedHour == int.parse(hour.split(":")[0]);
        return GestureDetector(
          onTap: () {
            if (!isNotAvailable) {
              setState(() {
                _selectedHour = int.parse(hour.split(":")[0]);
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : (isNotAvailable ? Colors.red : Colors.grey[400]),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              hour,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isNotAvailable ? Colors.black : Colors.grey),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }


  // Construction du formulaire pour les détails du patient
  Widget buildPatientDetailsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'Nom et prénom',
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            labelText: 'Âge',
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 10),
        const Text('Genre', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text("Masculin"),
                value: "Masculin",
                groupValue: _selectedGender,
                onChanged: (val) {
                  setState(() {
                    _selectedGender = val!;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text("Féminin"),
                value: "Féminin",
                groupValue: _selectedGender,
                onChanged: (val) {
                  setState(() {
                    _selectedGender = val!;
                  });
                },
              ),
            ),
          ],
        ),
        TextField(
          onChanged: (value) {
            setState(() {
              _problemDescription = value;
            });
          },
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Décrire votre problème',
            hintText: 'Tapez ici...',
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  // Confirmer le rendez-vous et afficher la confirmation
  void _confirmAppointment() {
    if (_selectedHour== null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Erreur'),
            content: const Text('Veuillez sélectionner une heure disponible.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Naviguer vers la page de confirmation
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentConfirmationPage(
          doctorName: widget.doctor.user.username,
          selectedDate: _selectedDate,
          selectedHour: _selectedHour!,
          problemDescription: _problemDescription,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    print(listOfAppointments[0].appointmentDate) ;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.doctor.user.username,style: const TextStyle(color: Colors.teal)),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildDateSelector(),
              const SizedBox(height: 20),
              const Text('Heures disponibles', style: TextStyle(fontWeight: FontWeight.bold)),
              buildTimeSelector(),
              const SizedBox(height: 20),
              const Text('Détails du patient', style: TextStyle(fontWeight: FontWeight.bold)),
              buildPatientDetailsForm(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _confirmAppointment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text('Demander un rendez-vous',style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

