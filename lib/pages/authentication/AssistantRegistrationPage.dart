import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../models/models.dart';
import 'LoginPage.dart';

class AssistantClinicRegistrationPage extends StatefulWidget {
  const AssistantClinicRegistrationPage({Key? key}) : super(key: key);

  @override
  _AssistantClinicRegistrationPageState createState() =>
      _AssistantClinicRegistrationPageState();
}

class _AssistantClinicRegistrationPageState
    extends State<AssistantClinicRegistrationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _selectedGender;
  DateTime? _selectedDate;
  bool _isLoading = false;
  File? _selectedImage;

  // Text editing controllers pour la clinique
  final TextEditingController _clinicNameController = TextEditingController();
  final TextEditingController _clinicaddressController = TextEditingController();
  final TextEditingController _clinicphoneController = TextEditingController();
  final TextEditingController _clinicemailController = TextEditingController();
  final TextEditingController _clinicGovernorateController = TextEditingController();

  // Text editing controllers pour l'assistant
  final TextEditingController _assistantNameController = TextEditingController();
  final TextEditingController _assistantEmailController = TextEditingController();
  final TextEditingController _assistantPhoneController = TextEditingController();
  final TextEditingController _assistantCinController = TextEditingController();
  final TextEditingController _assistantPasswordController = TextEditingController();
  final TextEditingController _assistantDobController = TextEditingController();

  // Upload image sur Imgur
  Future<String?> _uploadImageToImgur(File imageFile) async {
    const clientId = '9f9ec81a2a40523';
    final uri = Uri.parse('https://api.imgur.com/3/image');
    try {
      var request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Client-ID $clientId'
        ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonData = jsonDecode(responseData);
        return jsonData['data']['link'];
      }
    } catch (e) {
      print('Erreur lors de l\'upload : $e');
    }
    return null;
  }

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Veuillez ajouter une image")),
        );
        return;
      }

      try {
        setState(() {
          _isLoading = true;
        });

        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _assistantEmailController.text.trim(),
          password: _assistantPasswordController.text.trim(),
        );

        String? profileImageUrl = await _uploadImageToImgur(_selectedImage!);

        DateTime date = DateTime.parse(_assistantDobController.text.trim());

        // Création du modèle utilisateur pour l'assistant
        UserModel user = UserModel(
          id: userCredential.user!.uid,
          username: _assistantNameController.text.trim(),
          cin: int.parse(_assistantCinController.text.trim()),
          phoneNumber: _assistantPhoneController.text.trim(),
          role: Role.CLINIC_AGENT,
          profilePicture: profileImageUrl,
          birthday: date,
          gender: _selectedGender == "Male" ? Gender.MALE : Gender.FEMALE,
        );

        await _firestore
            .collection('users')
            .doc(user.id)
            .set(user.toFirestore());

        ServiceProviderModel clinic = ServiceProviderModel(
          id: userCredential.user!.uid,
          name: _clinicNameController.text.trim(),
          address: _clinicaddressController.text.trim(),
          phoneNumber: _clinicphoneController.text.trim(),
          governorate: _clinicGovernorateController.text.trim(),
          photo_url: profileImageUrl ?? '',
          email: _clinicemailController.text.trim(),
        );

        await _firestore
            .collection('service_providers')
            .doc(clinic.id)
            .set(clinic.toFirestore());

        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inscription réussie !')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Erreur")),
        );
      }
    }
  }

  void _showSelectImageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisir une image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Prendre une photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galerie'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _showSelectImageDialog,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : null,
                    child: _selectedImage == null
                        ? const Icon(Icons.camera_alt,
                            size: 40, color: Colors.grey)
                        : null,
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  items: const [
                    DropdownMenuItem(value: "Male", child: Text("Homme")),
                    DropdownMenuItem(value: "Female", child: Text("Femme")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: "Genre",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null ? "Veuillez sélectionner un genre" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _clinicNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom de la clinique',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? 'Champ requis' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
  controller: _clinicGovernorateController,
  decoration: const InputDecoration(
    labelText: 'Gouvernorat',
    border: OutlineInputBorder(),
  ),
  validator: (value) => value!.isEmpty ? 'Champ requis' : null,
),
                TextFormField(
                  controller: _clinicaddressController,
                  decoration: const InputDecoration(
                    labelText: 'Adresse de la clinique',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? 'Champ requis' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _clinicphoneController,
                  decoration: const InputDecoration(
                    labelText: 'Téléphone de la clinique',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) => value!.isEmpty ? 'Champ requis' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _clinicemailController,
                  decoration: const InputDecoration(
                    labelText: 'Email de la clinique',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value!.isEmpty ? 'Champ requis' : null,
                ),
                ElevatedButton(
                  onPressed: _signup,
                  child: const Text('Créer un compte'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
