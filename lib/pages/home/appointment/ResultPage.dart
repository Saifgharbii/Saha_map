import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../CalendarPage.dart';
import 'ClinicInfoPage.dart';
import 'DoctorInfoPage.dart';
import '../MessagesPage.dart';
import '../../profile/SettingsPage.dart';

class ResultPage extends StatelessWidget {
  final String option;
  final String governorate;
  final String speciality;

  ResultPage({
    required this.option,
    required this.governorate,
    required this.speciality,
  });

  final List<Map<String, dynamic>> locations = [
    {
      "name": "Clinique La rose",
      "specialitybydoctor": [
        {
          "name": "Dr. Sirine Charrada",
          "speciality": "Dermatologie",
          "image": "assets/images/doctor3.jpg"
        },
        {
          "name": "Dr. Hela Samoudi",
          "speciality": "Ophtalmologie",
          "image": "assets/images/doctor1.png"
        },
        {
          "name": "Dr. Sami Lasoued",
          "speciality": "Ophtalmologie",
          "image": "assets/images/doctor8.jpg"
        },
        {
          "name": "Dr. Rania Ben Ahmed",
          "speciality": "Ophtalmologie",
          "image": "assets/images/doctor10.jpg"
        }
      ],
      "latitude": 36.8000,
      "longitude": 10.1800,
      "address": "Avenue Habib Bourguiba, Tunis",
      "description":
          "Située en plein cœur de Tunis, la Clinique La Rose offre des soins médicaux de qualité dans un environnement moderne et accueillant. Spécialisée en cardiologie, elle est équipée des dernières technologies pour garantir des diagnostics précis et des traitements adaptés. Son équipe de professionnels dévoués met l'accent sur le bien-être et la satisfaction de ses patients, offrant une prise en charge complète et personnalisée.",
      "imagepath": "assets/images/rose.jpg",
      "avispatient": [
        {
          "name": "Kacem Kefi",
          "review": "Excellent clinique",
          "image": "assets/images/H1.webp"
        },
        {
          "name": "Ibtihel Ammar",
          "review": "Service rapide et professionnel.",
          "image": "assets/images/F1.jpg"
        }
      ]
    },
    {
      "name": "Cabinet Dr. Sirine Charrada",
      "speciality": "Dermatologie",
      "latitude": 36.8200,
      "longitude": 10.1700,
      "address": "Rue de Marseille, Tunis",
      "description":
          "Dr. Sirine Charrada est une spécialiste en dermatologie, reconnue pour son expertise et son approche humaine. Avec des années d'expérience dans le domaine, elle offre des traitements innovants et personnalisés pour tous types de pathologies dermatologiques. Elle est particulièrement appréciée pour son écoute attentive et sa capacité à instaurer une relation de confiance avec ses patients.",
      "imagepath": "assets/images/doctor3.jpg",
      "avispatient": [
        {
          "name": "Kacem Kefi",
          "review": "Excellent médecin, très à l'écoute.",
          "image": "assets/images/H1.webp"
        },
        {
          "name": "Ibtihel Ammar",
          "review": "Service rapide et professionnel.",
          "image": "assets/images/F1.jpg"
        }
      ],
      "doctorAvailableTimesByDate": [
        {
          "2024-11-27": ["08:00", "10:00", "14:00", "16:00"]
        }, // Exemple pour une journée
        {
          "2024-11-28": ["09:00", "11:00", "15:00"]
        }, // Autre journée
        {
          "2024-11-29": ["08:00", "10:00", "12:00", "16:00"]
        }
      ]
    },
    {
      "name": "Cabinet Dr. Hela Samoudi",
      "speciality": "Ophtalmologie",
      "latitude": 36.4600,
      "longitude": 10.7300,
      "address": "Avenue Habib Bourguiba, Nabeul",
      "description":
          "Dr. Hela Samoudi est une spécialiste en ophtalmologie, reconnue pour son expertise et son approche humaine. Avec des années d'expérience dans le domaine, elle offre des traitements innovants et personnalisés pour tous types de pathologies dermatologiques. Elle est particulièrement appréciée pour son écoute attentive et sa capacité à instaurer une relation de confiance avec ses patients.",
      "imagepath": "assets/images/doctor1.png",
      "avispatient": [
        {
          "name": "Rayen Nouri",
          "review": "Excellent médecin, très à l'écoute.",
          "image": "assets/images/H1.webp"
        },
        {
          "name": "Halima Soufi",
          "review": "Service rapide et professionnel.",
          "image": "assets/images/F1.jpg"
        }
      ],
      "doctorAvailableTimesByDate": [
        {
          "2024-11-27": ["08:00", "10:00", "14:00", "16:00"]
        }, // Exemple pour une journée
        {
          "2024-11-28": ["09:00", "11:00", "15:00"]
        }, // Autre journée
        {
          "2024-11-29": ["08:00", "10:00", "12:00", "16:00"]
        }
      ]
    },
    {
      "name": "Cabinet Dr. Sami Lasoued",
      "speciality": "Ophtalmologie",
      "latitude": 36.4650,
      "longitude": 10.7350,
      "address": "Rue des Jasmins, Nabeul",
      "description":
          "Dr. Sami Lasoues est un spécialiste en ophtalmologie, reconnue pour son expertise et son approche humaine. Avec des années d'expérience dans le domaine, elle offre des traitements innovants et personnalisés pour tous types de pathologies dermatologiques. Elle est particulièrement appréciée pour son écoute attentive et sa capacité à instaurer une relation de confiance avec ses patients.",
      "imagepath": "assets/images/doctor8.jpg",
      "avispatient": [
        {
          "name": "Bechir Selmi",
          "review": "Excellent médecin, très à l'écoute.",
          "image": "assets/images/H1.webp"
        },
        {
          "name": "Ibtissem Khedhri",
          "review": "Service rapide et professionnel.",
          "image": "assets/images/F1.jpg"
        }
      ],
      "doctorAvailableTimesByDate": [
        {
          "2024-11-27": ["08:00", "10:00", "14:00", "16:00"]
        }, // Exemple pour une journée
        {
          "2024-11-28": ["09:00", "11:00", "15:00"]
        }, // Autre journée
        {
          "2024-11-29": ["08:00", "10:00", "12:00", "16:00"]
        }
      ]
    },
    {
      "name": "Cabinet Dr. Rania Ben Ahmed",
      "speciality": "Ophtalmologie",
      "latitude": 36.4640,
      "longitude": 10.7370,
      "address": "Boulevard de la République, Nabeul",
      "description":
          "Dr. Rania Ben Ahmed est une spécialiste en Ophtalmologie, reconnue pour son expertise et son approche humaine. Avec des années d'expérience dans le domaine, elle offre des traitements innovants et personnalisés pour tous types de pathologies dermatologiques. Elle est particulièrement appréciée pour son écoute attentive et sa capacité à instaurer une relation de confiance avec ses patients.",
      "imagepath": "assets/images/doctor10.jpg",
      "avispatient": [
        {
          "name": "Amin Ben Taleb",
          "review": "Excellent médecin, très à l'écoute.",
          "image": "assets/images/H1.webp"
        },
        {
          "name": "Isra Maaouia",
          "review": "Service rapide et professionnel.",
          "image": "assets/images/F1.jpg"
        }
      ],
      "doctorAvailableTimesByDate": [
        {
          "2024-11-27": ["08:00", "10:00", "14:00", "16:00"]
        }, // Exemple pour une journée
        {
          "2024-11-28": ["09:00", "11:00", "15:00"]
        }, // Autre journée
        {
          "2024-11-29": ["08:00", "10:00", "12:00", "16:00"]
        }
      ]
    },
    {
      "name": "Clinique Al Chifa",
      "specialitybydoctor": [
        {
          "name": "Dr. Sirine Charrada",
          "speciality": "Dermatologie",
          "image": "assets/images/doctor3.jpg"
        },
        {
          "name": "Dr. Hela Samoudi",
          "speciality": "Ophtalmologie",
          "image": "assets/images/doctor1.png"
        },
        {
          "name": "Dr. Sami Lasoued",
          "speciality": "Ophtalmologie",
          "image": "assets/images/doctor8.jpg"
        },
        {
          "name": "Dr. Rania Ben Ahmed",
          "speciality": "Ophtalmologie",
          "image": "assets/images/doctor10.jpg"
        }
      ],
      "latitude": 36.4605,
      "longitude": 10.7335,
      "address": "Route Touristique, Nabeul",
      "description":
          "Située en plein cœur de Nabeul, la Clinique Al Chifa offre des soins médicaux de qualité dans un environnement moderne et accueillant. Spécialisée en cardiologie, elle est équipée des dernières technologies pour garantir des diagnostics précis et des traitements adaptés. Son équipe de professionnels dévoués met l'accent sur le bien-être et la satisfaction de ses patients, offrant une prise en charge complète et personnalisée.",
      "imagepath": "assets/images/chifa.jpg",
      "avispatient": [
        {
          "name": "Kacem Kefi",
          "review": "Excellent clinique",
          "image": "assets/images/H1.webp"
        },
        {
          "name": "Ibtihel Ammar",
          "review": "Service rapide et professionnel.",
          "image": "assets/images/F1.jpg"
        }
      ]
    },
    {
      "name": "Clinique Al Yosr",
      "specialitybydoctor": [
        {
          "name": "Dr. Sirine Charrada",
          "speciality": "Dermatologie",
          "image": "assets/images/doctor3.jpg"
        },
        {
          "name": "Dr. Hela Samoudi",
          "speciality": "Ophtalmologie",
          "image": "assets/images/doctor1.png"
        },
        {
          "name": "Dr. Sami Lasoued",
          "speciality": "Ophtalmologie",
          "image": "assets/images/doctor8.jpg"
        },
        {
          "name": "Dr. Rania Ben Ahmed",
          "speciality": "Ophtalmologie",
          "image": "assets/images/doctor10.jpg"
        }
      ],
      "latitude": 35.8300,
      "longitude": 10.6400,
      "address": "Avenue de la Liberté, Sousse",
      "description":
          "Située en plein cœur de Sousse, la Clinique Al Yosr offre des soins médicaux de qualité dans un environnement moderne et accueillant. Spécialisée en cardiologie, elle est équipée des dernières technologies pour garantir des diagnostics précis et des traitements adaptés. Son équipe de professionnels dévoués met l'accent sur le bien-être et la satisfaction de ses patients, offrant une prise en charge complète et personnalisée.",
      "imagepath": "assets/images/yosr.webp",
      "avispatient": [
        {
          "name": "Kacem Kefi",
          "review": "Excellent clinique.",
          "image": "assets/images/H1.webp"
        },
        {
          "name": "Ibtihel Ammar",
          "review": "Service rapide et professionnel.",
          "image": "assets/images/F1.jpg"
        }
      ]
    },
    {
      "name": "Cabinet Dr. Habib Eddin",
      "speciality": "Dermatologie",
      "latitude": 35.8255,
      "longitude": 10.6385,
      "address": "Rue Mongi Slim, Sousse",
      "description":
          "Dr. Habib Eddin est un spécialiste en dermatologie, reconnue pour son expertise et son approche humaine. Avec des années d'expérience dans le domaine, elle offre des traitements innovants et personnalisés pour tous types de pathologies dermatologiques. Elle est particulièrement appréciée pour son écoute attentive et sa capacité à instaurer une relation de confiance avec ses patients.",
      "imagepath": "assets/images/doctor9.jpg",
      "avispatient": [
        {
          "name": "Selim Naser",
          "review": "Excellent médecin, très à l'écoute.",
          "image": "assets/images/H1.webp"
        },
        {
          "name": "Senda laayeb",
          "review": "Service rapide et professionnel.",
          "image": "assets/images/F1.jpg"
        }
      ],
      "doctorAvailableTimesByDate": [
        {
          "2024-11-27": ["08:00", "10:00", "14:00", "16:00"]
        }, // Exemple pour une journée
        {
          "2024-11-28": ["09:00", "11:00", "15:00"]
        }, // Autre journée
        {
          "2024-11-29": ["08:00", "10:00", "12:00", "16:00"]
        }
      ]
    },
    {
      "name": "Cabinet Dr. Saif Gharbi",
      "speciality": "Dermatologie",
      "latitude": 35.8260,
      "longitude": 10.6395,
      "address": "Rue Halfawin, Sousse",
      "description":
          "Dr. Saif Gharbi est un spécialiste en dermatologie, reconnue pour son expertise et son approche humaine. Avec des années d'expérience dans le domaine, elle offre des traitements innovants et personnalisés pour tous types de pathologies dermatologiques. Elle est particulièrement appréciée pour son écoute attentive et sa capacité à instaurer une relation de confiance avec ses patients.",
      "imagepath": "assets/images/doctor5.jpg",
      "avispatient": [
        {
          "name": "Omar El Hacen",
          "review": "Excellent médecin, très à l'écoute.",
          "image": "assets/images/H1.webp"
        },
        {
          "name": "Mariem Haj Kacem",
          "review": "Service rapide et professionnel.",
          "image": "assets/images/F1.jpg"
        }
      ],
      "doctorAvailableTimesByDate": [
        {
          "2024-11-27": ["08:00", "10:00", "14:00", "16:00"]
        }, // Exemple pour une journée
        {
          "2024-11-28": ["09:00", "11:00", "15:00"]
        }, // Autre journée
        {
          "2024-11-29": ["08:00", "10:00", "12:00", "16:00"]
        }
      ]
    },
    {
      "name": "Clinique Al Arij",
      "specialitybydoctor": [
        {
          "name": "Dr. Sirine Charrada",
          "speciality": "Dermatologie",
          "image": "assets/images/doctor3.jpg"
        },
        {
          "name": "Dr. Hela Samoudi",
          "speciality": "Ophtalmologie",
          "image": "assets/images/doctor1.png"
        },
        {
          "name": "Dr. Sami Lasoued",
          "speciality": "Ophtalmologie",
          "image": "assets/images/doctor8.jpg"
        },
        {
          "name": "Dr. Rania Ben Ahmed",
          "speciality": "Ophtalmologie",
          "image": "assets/images/doctor10.jpg"
        }
      ],
      "latitude": 34.7400,
      "longitude": 10.7600,
      "address": "Avenue de la Liberté, Sfax",
      "description":
          "Située en plein cœur de Sfax, la Clinique Al Arij offre des soins médicaux de qualité dans un environnement moderne et accueillant. Spécialisée en cardiologie, elle est équipée des dernières technologies pour garantir des diagnostics précis et des traitements adaptés. Son équipe de professionnels dévoués met l'accent sur le bien-être et la satisfaction de ses patients, offrant une prise en charge complète et personnalisée.",
      "imagepath": "assets/images/arij.jpg",
      "avispatient": [
        {
          "name": "Kacem Kefi",
          "review": "Excellent clinique",
          "image": "assets/images/H1.webp"
        },
        {
          "name": "Ibtihel Ammar",
          "review": "Service rapide et professionnel.",
          "image": "assets/images/F1.jpg"
        }
      ]
    },
    {
      "name": "Cabinet Dr. Narjes Haj Mouhamed",
      "speciality": "Cardiologie",
      "latitude": 34.7420,
      "longitude": 10.7625,
      "address": "Rue Mongi Slim, Sfax",
      "description":
          "Dr. Narjes Haj Mouhamed est une spécialiste en cardiologie, reconnue pour son expertise et son approche humaine. Avec des années d'expérience dans le domaine, elle offre des traitements innovants et personnalisés pour tous types de pathologies dermatologiques. Elle est particulièrement appréciée pour son écoute attentive et sa capacité à instaurer une relation de confiance avec ses patients.",
      "imagepath": "assets/images/doctor7.jpg",
      "avispatient": [
        {
          "name": "Brahim Lahmer",
          "review": "Excellent médecin, très à l'écoute.",
          "image": "assets/images/H1.webp"
        },
        {
          "name": "Hend Ben Kahla",
          "review": "Service rapide et professionnel.",
          "image": "assets/images/F1.jpg"
        }
      ],
      "doctorAvailableTimesByDate": [
        {
          "2024-11-27": ["08:00", "10:00", "14:00", "16:00"]
        }, // Exemple pour une journée
        {
          "2024-11-28": ["09:00", "11:00", "15:00"]
        }, // Autre journée
        {
          "2024-11-29": ["08:00", "10:00", "12:00", "16:00"]
        }
      ]
    },
    {
      "name": "Cabinet Dr. Rim Maala",
      "speciality": "Psychiatrie",
      "latitude": 34.7410,
      "longitude": 10.7630,
      "address": "Rue Mouhamed Achour, Sfax",
      "description":
          "Dr. Rim Maala est une spécialiste en psychiatrie, reconnue pour son expertise et son approche humaine. Avec des années d'expérience dans le domaine, elle offre des traitements innovants et personnalisés pour tous types de pathologies dermatologiques. Elle est particulièrement appréciée pour son écoute attentive et sa capacité à instaurer une relation de confiance avec ses patients.",
      "imagepath": "assets/images/doctor1.webp",
      "avispatient": [
        {
          "name": "Naser Mokhtar",
          "review": "Excellent médecin, très à l'écoute.",
          "image": "assets/images/H1.webp"
        },
        {
          "name": "Nermin Bekir",
          "review": "Service rapide et professionnel.",
          "image": "assets/images/F1.jpg"
        }
      ],
      "doctorAvailableTimesByDate": [
        {
          "2024-11-27": ["08:00", "10:00", "14:00", "16:00"]
        }, // Exemple pour une journée
        {
          "2024-11-28": ["09:00", "11:00", "15:00"]
        }, // Autre journée
        {
          "2024-11-29": ["08:00", "10:00", "12:00", "16:00"]
        }
      ]
    },
    {
      "name": "Cabinet Dr. Sami Fourti",
      "speciality": "Cardiologie",
      "latitude": 34.7430,
      "longitude": 10.7645,
      "address": "Rue Mouhamed El Hami, Sfax",
      "description":
          "Dr. Sami Fourti est un spécialiste en cardiologie, reconnue pour son expertise et son approche humaine. Avec des années d'expérience dans le domaine, elle offre des traitements innovants et personnalisés pour tous types de pathologies dermatologiques. Elle est particulièrement appréciée pour son écoute attentive et sa capacité à instaurer une relation de confiance avec ses patients.",
      "imagepath": "assets/images/doctor2.jpg",
      "avispatient": [
        {
          "name": "Ahmed Ouni",
          "review": "Excellent médecin, très à l'écoute.",
          "image": "assets/images/H1.webp"
        },
        {
          "name": "Basma Ltaief",
          "review": "Service rapide et professionnel.",
          "image": "assets/images/F1.jpg"
        }
      ],
      "doctorAvailableTimesByDate": [
        {
          "2024-11-27": ["08:00", "10:00", "14:00", "16:00"]
        }, // Exemple pour une journée
        {
          "2024-11-28": ["09:00", "11:00", "15:00"]
        }, // Autre journée
        {
          "2024-11-29": ["08:00", "10:00", "12:00", "16:00"]
        }
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    // Filtrer les lieux en fonction des critères
    final filteredLocations = locations.where((location) {
      // Vérifier si la spécialité correspond dans specialitybydoctor
      bool matchesSpeciality = location['specialitybydoctor']
          .any((doctor) => doctor['speciality'] == speciality);
      bool matchesGovernorate =
          location['address'].toLowerCase().contains(governorate.toLowerCase());
      bool matchesOption = option == 'Clinique'
          ? location['name'].contains('Clinique')
          : location['name'].contains('Cabinet');
      return matchesSpeciality && matchesGovernorate && matchesOption;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        title: Text(
          governorate,
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
                initialCenter: filteredLocations.isNotEmpty
                    ? LatLng(filteredLocations.first['latitude'],
                        filteredLocations.first['longitude'])
                    : LatLng(36.8065, 10.1815), // Centre par défaut : Tunis
                initialZoom: 12.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: filteredLocations.map((location) {
                    return Marker(
                      width: 80.0,
                      height: 80.0,
                      point:
                          LatLng(location['latitude'], location['longitude']),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(location['name']),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Adresse : ${location['address']}",
                                  ),
                                  SizedBox(height: 10),
                                  Text("Médecins disponibles :"),
                                  ...location['specialitybydoctor']
                                      .map<Widget>((doctor) => ListTile(
                                            leading: CircleAvatar(
                                              backgroundImage:
                                                  AssetImage(doctor['image']),
                                            ),
                                            title: Text(doctor['name']),
                                            subtitle:
                                                Text(doctor['speciality']),
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
              itemCount: filteredLocations.length,
              itemBuilder: (context, index) {
                final location = filteredLocations[index];
                return ListTile(
                  leading: Icon(Icons.medical_services,
                      color: Colors.teal, size: 30),
                  title: Text(
                    location['name'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(location['address']),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 16,
                  ),
                  onTap: () {
                    if (option == 'Clinique') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClinicInfoPage(
                            name: location['name'],
                            address: location['address'],
                            latitude: location['latitude'],
                            longitude: location['longitude'],
                            description: location['description'],
                            imagepath: location['imagepath'],
                            avispatient: location['avispatient'],
                          ),
                        ),
                      );
                    } else if (option == 'Cabinet') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorInfoPage(
                            name: location['name'],
                            speciality: speciality,
                            address: location['address'],
                            latitude: location['latitude'],
                            longitude: location['longitude'],
                            description: location['description'],
                            imagepath: location['imagepath'],
                            avispatient: location['avispatient'],
                            doctorAvailableTimesByDate:
                                location['doctorAvailableTimesByDate'],
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
