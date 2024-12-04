import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'models/models.dart';
import 'pages/authentication/RoleSelectionScreen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  GlobalController globalController = GlobalController();
  await globalController.fetchAllData();
  print('Fetched all data');
  print('Doctors: ${globalController.currentUser}');
  runApp(const Sa7aMapApp());
}

class Sa7aMapApp extends StatelessWidget {
  const Sa7aMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo de l'application
              Image.asset(
                'assets/images/logo.png', // Remplacez par votre logo
                width: 130,
                height: 130,
              ),
              const SizedBox(height: 20),

              // Nom de l'application
              const Text(
                'Sa7a Map',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 10),

              // Slogan
              const Text(
                'Votre Guide Santé\nClair Et Accessible',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 30),

              // Bouton Connexion
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RoleSelectionScreen(isRegistration: false),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Connexion',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Bouton Inscription
              ElevatedButton(
                onPressed: () async {
                  // final generator = TestDataGenerator();
                  // await generator.generateTestData(
                  //   numberOfDoctors: 10,
                  //   numberOfPatients: 20,
                  //   numberOfAccommodations: 15,
                  //   numberOfServiceProviders: 5,
                  //   numberOfAppointments: 30,
                  // );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RoleSelectionScreen(isRegistration: true),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Inscription',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
