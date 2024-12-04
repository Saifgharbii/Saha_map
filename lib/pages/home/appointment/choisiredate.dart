import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'AppointmentConfirmationPage.dart';

// Page principale pour choisir une date
class ChoisireDatePage extends StatefulWidget {
  final String doctorName;

  // Liste de maps pour stocker les horaires disponibles par date
  final List<Map<String, List<String>>> doctorAvailableTimesByDate;

  ChoisireDatePage({
    required this.doctorName,
    required this.doctorAvailableTimesByDate,
  });

  @override
  _ChoisireDatePageState createState() => _ChoisireDatePageState();
}

class _ChoisireDatePageState extends State<ChoisireDatePage> {
  late DateTime _selectedDate;
  String _selectedTime = '';
  String _selectedGender = 'Masculin'; // Genre sélectionné
  String _problemDescription = ''; // Description du problème
  List<String> _availableTimes = []; // Horaires disponibles pour la date sélectionnée

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _updateAvailableTimes(_selectedDate);
  }

  void _updateAvailableTimes(DateTime date) {
    setState(() {
      _availableTimes = [];
      String formattedDate = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';  // format YYYY-MM-DD
      for (var map in widget.doctorAvailableTimesByDate) {
        if (map.containsKey(formattedDate)) {
          _availableTimes = map[formattedDate] ?? [];
          break;
        }
      }
    });
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
        _updateAvailableTimes(selectedDay);
      },
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.blueAccent,
          shape: BoxShape.circle,
        ),
        weekendTextStyle: TextStyle(color: Colors.red),
      ),
      headerStyle: HeaderStyle(
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
      allHours.add('${i}:00');
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: allHours.map((hour) {
        // Vérifier si l'heure est disponible
        final isAvailable = _availableTimes.contains(hour);
        final isSelected = _selectedTime == hour;
        return GestureDetector(
          onTap: () {
            if (isAvailable) {
              setState(() {
                _selectedTime = hour;
              });
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.blue
                  : (isAvailable ? Colors.grey[200] : Colors.grey[400]),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              hour,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isAvailable ? Colors.black : Colors.grey),
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
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            labelText: 'Âge',
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10),
        Text('Genre', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: Text("Masculin"),
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
                title: Text("Féminin"),
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
    if (_selectedTime.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Erreur'),
            content: Text('Veuillez sélectionner une heure disponible.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
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
          doctorName: widget.doctorName,
          selectedDate: _selectedDate,
          selectedTime: _selectedTime,
          problemDescription: _problemDescription,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.doctorName}',style: TextStyle(color: Colors.teal)),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildDateSelector(),
              SizedBox(height: 20),
              Text('Heures disponibles', style: TextStyle(fontWeight: FontWeight.bold)),
              buildTimeSelector(),
              SizedBox(height: 20),
              Text('Détails du patient', style: TextStyle(fontWeight: FontWeight.bold)),
              buildPatientDetailsForm(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _confirmAppointment,
                child: Text('Demander un rendez-vous',style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

