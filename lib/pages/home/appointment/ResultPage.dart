import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // If you're using flutter_map
import '../../../models/models.dart';
import 'package:latlong2/latlong.dart';
import 'DoctorInfoPage.dart'; // Import the DoctorInfoPage here

class ResultPage extends StatefulWidget {
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
                                          DoctorInfoPage(doctor: doctor),
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
