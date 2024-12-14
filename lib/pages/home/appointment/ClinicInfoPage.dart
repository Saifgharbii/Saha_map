// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../CalendarPage.dart';
// import '../MessagesPage.dart';
// import '../../profile/SettingsPage.dart';
// import '../message.dart';
// import 'package:saha_map/models/models.dart';

// class ClinicInfoPage extends StatefulWidget {
//   final ServiceProviderModel serviceProvider;

//   const ClinicInfoPage({
//     Key? key,
//     required this.serviceProvider,
//   }) : super(key: key);

//   @override
//   _ClinicInfoPageState createState() => _ClinicInfoPageState();
// }

// class _ClinicInfoPageState extends State<ClinicInfoPage> {
//   static final List<Map<String, dynamic>> _specialities = [
//     {
//       "label": "Rheumatologie",
//       "icon": Icons.medical_services,
//       "specialty": Specialties.RHEUMATOLOGY
//     },
//     {
//       "label": "Cardiologie",
//       "icon": Icons.favorite,
//       "specialty": Specialties.CARDIOLOGY
//     },
//     {
//       "label": "Dermatologie",
//       "icon": Icons.spa,
//       "specialty": Specialties.DERMATOLOGY
//     },
//     {
//       "label": "Endocrinologie",
//       "icon": Icons.health_and_safety,
//       "specialty": Specialties.ENDOCRINOLOGY
//     },
//     {
//       "label": "Gastro-entérologie",
//       "icon": Icons.lunch_dining,
//       "specialty": Specialties.GASTROENTEROLOGY
//     },
//     {
//       "label": "Médecine générale",
//       "icon": Icons.healing,
//       "specialty": Specialties.FAMILY_MEDICINE
//     },
//     {
//       "label": "Pédiatrie",
//       "icon": Icons.child_friendly,
//       "specialty": Specialties.PEDIATRICS
//     },
//     {
//       "label": "Ophtalmologie",
//       "icon": Icons.visibility,
//       "specialty": Specialties.OPHTHALMOLOGY
//     },
//     {
//       "label": "Psychiatrie",
//       "icon": Icons.psychology,
//       "specialty": Specialties.PSYCHIATRY
//     }
//   ];

//   bool isSpecialtySectionVisible = false;
//   Specialties? _selectedSpecialty;
//   late List<DoctorWorksAtServiceProvider> _doctorsWorkingHere;

//   @override
//   void initState() {
//     super.initState();
//     _doctorsWorkingHere = GlobalController.to.doctorWorksAtServiceProviders
//         .where((doc) => doc.serviceProvider.name == widget.serviceProvider.name)
//         .toList();
//   }

//   Future<List<DoctorWorksAtServiceProvider>> _getDoctorsBySpecialty(Specialties? specialty) async {
//     if (specialty == null) {
//       return _doctorsWorkingHere;
//     } else {
//       return _doctorsWorkingHere
//           .where((doc) => doc.doctor.speciality == specialty)
//           .toList();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Infos Clinique",
//           style: TextStyle(color: Colors.teal),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.grey[100],
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.teal),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildClinicCard(context),
//               const SizedBox(height: 16),
//               _buildSectionTitle("Avis des Patients"),
//               const SizedBox(height: 16),
//               _buildChooseSpecialtyButton(),
//               if (isSpecialtySectionVisible) ...[
//                 const SizedBox(height: 16),
//                 _buildSpecialtySection(context),
//               ],
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: _buildBottomNavigationBar(),
//     );
//   }

//   Widget _buildBottomNavigationBar() {
//     return Container(
//       color: Colors.blue.shade100,
//       child: BottomNavigationBar(
//         elevation: 0,
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.black54,
//         onTap: (index) {
//           switch (index) {
//             case 0:
//               // Home page - do nothing or navigate to home
//               break;
//             case 1:
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => CalendarPage()),
//               );
//               break;
//             case 2:
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => MessagesPage()),
//               );
//               break;
//             case 3:
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => SettingsPage()),
//               );
//               break;
//           }
//         },
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
//           BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Agenda"),
//           BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Messagerie"),
//           BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Paramètres"),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: const TextStyle(
//         fontSize: 18,
//         fontWeight: FontWeight.bold,
//         color: Colors.blue,
//       ),
//     );
//   }

//   Widget _buildClinicCard(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.5),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Image.network(
//             widget.serviceProvider.photo_url,
//             height: 120,
//             //width: double.infinity,
//             //fit: BoxFit.cover,
//             errorBuilder: (context, error, stackTrace) {
//               return Icon(Icons.medical_services, size: 120);
//             },
//           ),
//           const SizedBox(height: 8),
//           Text(
//             widget.serviceProvider.name,
//             style: const TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 4),
//           _buildInfoRow(Icons.location_on, 'Adresse', widget.serviceProvider.address),
//           _buildInfoRow(
//             Icons.email,
//             'Email',
//             widget.serviceProvider.email ?? 'Non disponible'
//           ),
//           _buildInfoRow(
//             Icons.phone,
//             'Téléphone',
//             widget.serviceProvider.phoneNumber ?? 'Non disponible'
//           ),
//           _buildInfoRow(
//             Icons.location_city,
//             'Gouvernorat',
//             widget.serviceProvider.governorate.governorate.name
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoRow(IconData icon, String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.teal, size: 20),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 Text(
//                   value,
//                   style: const TextStyle(
//                     color: Colors.black54,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSpecialtySection(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Choisir une Spécialité',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.blue,
//           ),
//         ),
//         const SizedBox(height: 8),
//         GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 16,
//             mainAxisSpacing: 16,
//           ),
//           itemCount: _specialities.length,
//           itemBuilder: (context, index) {
//             final specialty = _specialities[index];
//             return SpecialtyCard(
//               icon: specialty['icon'],
//               label: specialty['label'],
//               isActive: _selectedSpecialty == specialty['specialty'],
//               onPressed: () {
//                 setState(() {
//                   _selectedSpecialty = specialty['specialty'];
//                   _getDoctorsBySpecialty(_selectedSpecialty).then((doctors) {
//                     _showDoctorsList(doctors);
//                   });
//                 });
//               },
//             );
//           },
//         ),
//       ],
//     );
//   }

//   void _showDoctorsList(List<DoctorWorksAtServiceProvider> doctors) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 'Médecins de la spécialité',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blue,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               if (doctors.isEmpty)
//                 const Text(
//                   'Aucun médecin trouvé pour cette spécialité',
//                   style: TextStyle(color: Colors.grey),
//                 )
//               else
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: doctors.length,
//                     itemBuilder: (context, index) {
//                       final doctor = doctors[index].doctor;
//                       return ListTile(
//                         title: Text(doctor.user.username),
//                         subtitle: Text(doctor.speciality.toString().split('.').last),
//                       );
//                     },
//                   ),
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildChooseSpecialtyButton() {
//     return ElevatedButton(
//       onPressed: () {
//         setState(() {
//           isSpecialtySectionVisible = true;
//           _selectedSpecialty = null;
//         });
//       },
//       child: const Text('Choisir une spécialité'),
//     );
//   }
// }

// class SpecialtyCard extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final bool isActive;
//   final VoidCallback onPressed;

//   const SpecialtyCard({
//     Key? key,
//     required this.icon,
//     required this.label,
//     required this.isActive,
//     required this.onPressed,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         decoration: BoxDecoration(
//           color: isActive ? Colors.blue.shade100 : Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isActive ? Colors.blue : Colors.grey.shade300,
//             width: 2,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               spreadRadius: 1,
//               blurRadius: 5,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               icon,
//               color: isActive ? Colors.blue : Colors.grey.shade600,
//               size: 40,
//             ),
//             const SizedBox(height: 8),
//             Text(
//               label,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: isActive ? Colors.blue : Colors.black87,
//                 fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../CalendarPage.dart';
import '../MessagesPage.dart';
import '../../profile/SettingsPage.dart';
import '../message.dart';
import 'package:saha_map/models/models.dart';
import 'DoctorInfoPage.dart';

class ClinicInfoPage extends StatefulWidget {
  final ServiceProviderModel serviceProvider;

  const ClinicInfoPage({
    Key? key,
    required this.serviceProvider,
  }) : super(key: key);

  @override
  _ClinicInfoPageState createState() => _ClinicInfoPageState();
}

class _ClinicInfoPageState extends State<ClinicInfoPage> {
  static final List<Map<String, dynamic>> _specialities = [
    {
      "label": "Rheumatologie",
      "icon": Icons.medical_services,
      "specialty": Specialties.RHEUMATOLOGY
    },
    {
      "label": "Cardiologie",
      "icon": Icons.favorite,
      "specialty": Specialties.CARDIOLOGY
    },
    {
      "label": "Dermatologie",
      "icon": Icons.spa,
      "specialty": Specialties.DERMATOLOGY
    },
    {
      "label": "Endocrinologie",
      "icon": Icons.health_and_safety,
      "specialty": Specialties.ENDOCRINOLOGY
    },
    {
      "label": "Gastro-entérologie",
      "icon": Icons.lunch_dining,
      "specialty": Specialties.GASTROENTEROLOGY
    },
    {
      "label": "Médecine générale",
      "icon": Icons.healing,
      "specialty": Specialties.FAMILY_MEDICINE
    },
    {
      "label": "Pédiatrie",
      "icon": Icons.child_friendly,
      "specialty": Specialties.PEDIATRICS
    },
    {
      "label": "Ophtalmologie",
      "icon": Icons.visibility,
      "specialty": Specialties.OPHTHALMOLOGY
    },
    {
      "label": "Psychiatrie",
      "icon": Icons.psychology,
      "specialty": Specialties.PSYCHIATRY
    }
  ];

  bool isSpecialtySectionVisible = false;
  Specialties? _selectedSpecialty;
  late List<DoctorWorksAtServiceProvider> _doctorsWorkingHere;

  @override
  void initState() {
    super.initState();
    _doctorsWorkingHere = GlobalController.to.doctorWorksAtServiceProviders
        .where((doc) => doc.serviceProvider.name == widget.serviceProvider.name)
        .toList();
  }

  Future<List<DoctorWorksAtServiceProvider>> _getDoctorsBySpecialty(
      Specialties? specialty) async {
    if (specialty == null) {
      return _doctorsWorkingHere;
    } else {
      return _doctorsWorkingHere
          .where((doc) => doc.doctor.speciality == specialty)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Infos Clinique",
          style: TextStyle(color: Colors.teal),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[100],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildClinicCard(context),
              const SizedBox(height: 16),
              _buildSectionTitle("Avis des Patients"),
              const SizedBox(height: 16),
            //  _buildChooseSpecialtyButton(),
             
                const SizedBox(height: 16),
                _buildSpecialtySection(context),
              
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

 


   Widget _buildSpecialtySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choisir une Spécialité',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: _specialities.length,
          itemBuilder: (context, index) {
            final specialty = _specialities[index];
            return SpecialtyCard(
              icon: specialty['icon'],
              label: specialty['label'],
              isActive: _selectedSpecialty == specialty['specialty'],
              onPressed: () {
                setState(() {
                  _selectedSpecialty = specialty['specialty'];
                  _getDoctorsBySpecialty(_selectedSpecialty).then((doctors) {
                    _showDoctorsList(doctors);
                  });
                });
              },
            );
          },
        ),
      ],
    );
  }

  void _showDoctorsList(List<DoctorWorksAtServiceProvider> doctors) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Médecins de la spécialité',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 16),
              if (doctors.isEmpty)
                const Text(
                  'Aucun médecin trouvé pour cette spécialité',
                  style: TextStyle(color: Colors.grey),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: doctors.length,
                    itemBuilder: (context, index) {
                      final doctor = doctors[index].doctor;
                      return ListTile(
                        title: Text(doctor.user.username),
                        subtitle:
                            Text(doctor.speciality.toString().split('.').last),
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
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      color: Colors.blue.shade100,
      child: BottomNavigationBar(
        elevation: 0,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black54,
        onTap: (index) {
          switch (index) {
            case 0:
              // Home page - do nothing or navigate to home
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: "Agenda"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Messagerie"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Paramètres"),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }

  Widget _buildClinicCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
            widget.serviceProvider.photo_url,
            height: 120,
            //width: double.infinity,
            //fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.medical_services, size: 120);
            },
          ),
          const SizedBox(height: 8),
          Text(
            widget.serviceProvider.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          _buildInfoRow(
              Icons.location_on, 'Adresse', widget.serviceProvider.address),
          _buildInfoRow(Icons.email, 'Email',
              widget.serviceProvider.email ?? 'Non disponible'),
          _buildInfoRow(Icons.phone, 'Téléphone',
              widget.serviceProvider.phoneNumber ?? 'Non disponible'),
          _buildInfoRow(Icons.location_city, 'Gouvernorat',
              widget.serviceProvider.governorate.governorate.name),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class SpecialtyCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  const SpecialtyCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? Colors.blue.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? Colors.blue : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.blue : Colors.grey.shade600,
              size: 40,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isActive ? Colors.blue : Colors.black87,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
