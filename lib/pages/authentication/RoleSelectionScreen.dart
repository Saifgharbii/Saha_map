import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'RegistrationPage.dart';

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
                  navigateToNext(context);
                },
              ),
              const SizedBox(height: 15),
              RoleButton(
                label: 'Patient',
                onPressed: () {
                  navigateToNext(context);
                },
              ),
              const SizedBox(height: 15),
              RoleButton(
                label: 'Assistant',
                onPressed: () {
                  navigateToNext(context);
                },
              ),
              const SizedBox(height: 15),
              RoleButton(
                label: 'Agent Immobilier',
                onPressed: () {
                  navigateToNext(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToNext(BuildContext context) {
    if (isRegistration) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RegistrationPage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
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
