import 'package:flutter/material.dart';
import 'package:saha_map/models/models.dart';
import 'package:saha_map/pages/authentication/RoleSelectionScreen.dart';
import './ForgotPasswordPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../home/HomePage.dart';
import 'PatientRegistrationPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  Future<void> _login() async {
    try {
      // Attempt login with email and password
      UserCredential user = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      GlobalController globalController = GlobalController();
      DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore.collection('users').doc(user.user!.uid).get();
      UserModel currentUser = UserModel.fromFirestore(userDoc);
      globalController.setCurrentUser(currentUser);

      // Navigate to home page after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      
      // Enhanced error handling based on specific Firebase error codes
      if (e.code == 'user-not-found') {
        errorMessage = 'Aucun utilisateur trouvé pour cet email. Veuillez vérifier votre email ou inscrire un nouveau compte.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Le mot de passe est incorrect. Veuillez réessayer.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'L\'adresse e-mail entrée est invalide. Veuillez entrer un email valide.';
      } else {
        errorMessage = 'Une erreur est survenue. Veuillez vérifier vos informations.';
      }

      // Show error message in a dialog
      _showErrorDialog(errorMessage);
    }
  }

  // Function to display the error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erreur'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFFFFF), // Blanc
              Color(0xFFFFFFFF), // Blanc
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form( // Ajout du formulaire
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo ou illustration en haut
                    Image.asset(
                      'assets/images/loginlogo.png', // Remplacez par votre image
                      height: 200, // Taille agrandie
                    ),
                    const SizedBox(height: 20),

                    // Titre
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "Bienvenue sur\n",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: "Sa7a Map",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal, // Couleur plus foncée
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Champ Téléphone ou Email
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Téléphone ou Email",
                          prefixIcon: const Icon(Icons.email_outlined, color: Colors.teal),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un email ou un téléphone.';
                          } else if (!RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$').hasMatch(value) && !RegExp(r'^[0-9]{8,}$').hasMatch(value)) {
                            return 'Veuillez entrer un email ou un téléphone valide.';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Champ Mot de passe
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: "Mot de passe",
                          prefixIcon: const Icon(Icons.lock_outline, color: Colors.teal),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un mot de passe.';
                          } else if (value.length < 8) {
                            return 'Le mot de passe doit comporter au moins 8 caractères.';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Lien Mot de passe oublié
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgotPasswordPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Mot de passe oublié ?",
                          style: TextStyle(color: Colors.teal, fontSize: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Bouton Se connecter
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          _login();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 3,
                      ),
                      child: const Text(
                        "Se connecter",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Lien Créer un compte
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RoleSelectionScreen(isRegistration: true),
                          ),
                        );
                      },
                      child: const Text(
                        "Vous n'avez pas de compte ? Créez-en un nouveau",
                        style: TextStyle(
                          color: Colors.teal,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
