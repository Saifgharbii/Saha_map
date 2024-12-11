import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import '../../models/models.dart';
import './LoginPage.dart';
class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}
class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? _selectedImage;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isPasswordVisible = false;
  String? _selectedGender;
  UserCredential? userCredential;
  bool _isLoading = false;
  String ? _selectedSpecialties;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _cinController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _isLoading = true;
        });
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        int cin = int.parse(_cinController.text.trim());
        DateTime date = DateTime.parse(_dobController.text.trim());
        Gender gender = _selectedGender == "Male" ? Gender.MALE : Gender.FEMALE;
        Specialties specialties = Specialties.values.firstWhere(
              (s) => s.toString().split('.').last == _selectedSpecialties?.toUpperCase(),
          orElse: () => Specialties.GENERAL_PRACTICE, // Valeur par défaut si aucune correspondance
        );


        String? profileImageUrl = await _uploadImage();
        // Créer un objet UserModel
        UserModel user = UserModel(
          id: userCredential!.user!.uid,
          username: _nameController.text.trim(),
          cin: cin,
          birthday: date,
          gender: gender,
          profilePicture: profileImageUrl,
          phoneNumber: _phoneController.text.trim(),
          role: Role.DOCTOR,  // Assurez-vous que Role est bien défini
        );

// Créer un objet DoctorModel en utilisant UserModel
        DoctorModel doctor = DoctorModel(
          user: user,
          consultationFee: 150.0,  // Remplacez par la valeur réelle
          speciality: specialties,  // Remplacez par la spécialité réelle
          experienceYears: int.parse(_experienceController.text.trim()),
          recommendationRate: 4.5,  // Remplacez par la note réelle
          address: _addressController.text.trim(),
        );

        await _firestore.collection('users').doc(user.id).set(user.toFirestore());
        // Ajouter à la collection patients
        PatientModel patient = PatientModel(user: user);
        await _firestore.collection('doctors').doc(user.id).set(doctor.toFirestore());
        setState(() {
          _isLoading = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Inscription réussie!')),
          );
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? "Erreur lors de l'inscription.")),
          );
        }
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    await _checkPermission();
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _showSelectImageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
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
                title: const Text('Choisir une photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _checkPermission() async {
    var status = await Permission.storage.status;
    var cameraStatus = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if (!cameraStatus.isGranted) {
      await Permission.camera.request();
    }
  }

  Future<String?> _uploadImageToImgur(File imageFile) async {
    const clientId = '9f9ec81a2a40523';
    final uri = Uri.parse('https://api.imgur.com/3/image');
    try {
      var request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Client-ID $clientId';
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
      ));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonData = jsonDecode(responseData);
        return jsonData['data']['link'];
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Upload failed: $e');
    }
    return null;
  }

  Future<String?> _uploadImage() async {
    _checkPermission();
    if (_selectedImage != null) {
      final uploadUrl = await _uploadImageToImgur(_selectedImage!);
      return uploadUrl;
    }
    else {
        
      return null;
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
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _showSelectImageDialog,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : null,
                        child: _selectedImage == null
                            ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 13),
                    const Text(
                      "Créer un compte médecin",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField(
                      label: "Nom",
                      icon: Icons.person_outline,
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Le nom est requis.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildDatePicker(),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Genre',
                          border: InputBorder.none,
                        ),
                        value: _selectedGender,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedGender = newValue;
                          });
                        },
                        items: <String>['Male', 'Female']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildDatePicker(),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Spécialité',
                          border: InputBorder.none,
                        ),
                        value: _selectedSpecialties,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedSpecialties = newValue;
                          });
                        },
                        items: <String>['Male', 'Female']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      label: "Adresse",
                      icon: Icons.location_on_outlined,
                      controller: _addressController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'L\'adresse est requise.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      label: "Année d'expérience",
                      icon: Icons.work_outline,
                      controller: _experienceController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'L\'année d\'expérience est requise.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      label: "Numéro de téléphone",
                      icon: Icons.phone_outlined,
                      controller: _phoneController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Le téléphone est requis.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      label: "Email",
                      icon: Icons.email_outlined,
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'L\'email est requis.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      label: "Date de naissance (yyyy-mm-dd)",
                      icon: Icons.calendar_today,
                      controller: _dobController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La date de naissance est requise.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      label: "CIN",
                      icon: Icons.credit_card_outlined,
                      controller: _cinController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Le CIN est requis.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      label: "Mot de passe",
                      icon: Icons.lock_outline,
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Le mot de passe est requis.';
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _signup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      child: const Text(
                        'S\'inscrire',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
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

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required FormFieldValidator<String> validator,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: validator,
    );
  }Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          setState(() {
            _dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
          });
        }
      },
      child: _buildTextField(
        label: "Date de naissance",
        icon: Icons.calendar_today_outlined,
        controller: _dobController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'La date de naissance est requise.';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        controller: _passwordController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Le mot de passe est requis.';
          }
          return null;
        },
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          labelText: 'Mot de passe',
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(_isPasswordVisible
                ? Icons.visibility
                : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildLoginRedirect() {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      },
      child: const Text(
        'Vous avez déjà un compte ? Connectez-vous',
        style: TextStyle(
          color: Colors.blue,
          fontSize: 16,
        ),
      ),
    );
  }

}
