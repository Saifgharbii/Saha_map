import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'DoctorRegistrationPage.dart';
import 'LoginPage.dart';
import 'PatientRegistrationPage.dart';
// Importez également les pages pour Assistant, Clinique, Agent Immobilier, etc.

class RoleSelectionScreen extends StatelessWidget {
  final bool isRegistration; // Indique si c'est pour Inscription ou Connexion

  const RoleSelectionScreen({super.key, required this.isRegistration});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                'Qui Êtes-Vous ?',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 30),
              RoleButton(
                label: 'Médecin',
                onPressed: () {
                  navigateToNext(context, 'Médecin');
                },
              ),
              const SizedBox(height: 15),
              RoleButton(
                label: 'Patient',
                onPressed: () {
                  navigateToNext(context, 'Patient');
                },
              ),
              const SizedBox(height: 15),
              RoleButton(
                label: 'Assistant clinique',
                onPressed: () {
                  navigateToNext(context, 'Assistant');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToNext(BuildContext context, String role) {
    if (isRegistration) {
      // Navigation pour Inscription
      switch (role) {
        case 'Médecin':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DoctorRegistrationPage()),
          );
          break;
        case 'Patient':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PatientRegistrationPage()),
          );
          break;
        case 'Assistant':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AssistantRegistrationPage()),
          );
          break;
        default:
          throw Exception('Rôle inconnu');
      }
    } else {
      // Navigation pour Connexion
      switch (role) {
        case 'Médecin':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
          break;
        case 'Patient':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
          break;
        case 'Assistant':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
          break;
        default:
          throw Exception('Rôle inconnu');
      }
    }
  }
}

// Widget pour un bouton de rôle
class RoleButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const RoleButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[100],
        minimumSize: const Size(220, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 2,
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}