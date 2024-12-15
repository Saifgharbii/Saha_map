import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'models/models.dart';
import 'firebase_options.dart';



class FirebaseDataGenerator {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Faker _faker = Faker();
  final Random _random = Random();

  // Generate random governorate
  Governorate _getRandomGovernorate() {
    return Governorate.values[_random.nextInt(Governorate.values.length)];
  }

  // Generate Users
  Future<List<UserModel>> generateUsers() async {
    List<UserModel> users = [];

    // Generate 2 patients
    for (int i = 0; i < 2; i++) {
      UserModel patient = UserModel(
        id: _faker.guid.guid(),
        username: _faker.person.name(),
        cin: _random.nextInt(100000000),
        birthday: DateTime.now().subtract(Duration(days: _random.nextInt(365 * 50))),
        gender: i % 2 == 0 ? Gender.MALE : Gender.FEMALE,
        phoneNumber: _faker.phoneNumber.us(),
        role: Role.PATIENT,
      );
      users.add(patient);

      // Add patient to Firestore
      await _firestore.collection('users').doc(patient.id).set(patient.toFirestore());
      
      // Create corresponding patient model
      PatientModel patientModel = PatientModel(
        user: patient,
        medicalHistory: _faker.lorem.sentence(),
        feedback: _faker.lorem.sentence(),
      );
      await _firestore.collection('patients').doc(patient.id).set(patientModel.toFirestore());
    }

    // Generate 8 doctors
    for (int i = 0; i < 8; i++) {
      UserModel doctor = UserModel(
        id: _faker.guid.guid(),
        username: _faker.person.name(),
        cin: _random.nextInt(100000000),
        birthday: DateTime.now().subtract(Duration(days: _random.nextInt(365 * 50))),
        gender: i % 2 == 0 ? Gender.MALE : Gender.FEMALE,
        phoneNumber: _faker.phoneNumber.us(),
        role: Role.DOCTOR,
      );
      users.add(doctor);

      // Add doctor to Firestore
      await _firestore.collection('users').doc(doctor.id).set(doctor.toFirestore());

      // Create corresponding doctor model
      DoctorModel doctorModel = DoctorModel(
        user: doctor,
        consultationFee: 50.0 + _random.nextDouble() * 50,
        speciality: Specialties.values[_random.nextInt(Specialties.values.length)],
        experienceYears: 1 + _random.nextInt(20),
        recommendationRate: _random.nextDouble() * 5,
        address: '${_faker.address.streetAddress()}, ${_faker.address.city()}',
        governorate: governorateMap["Tunis"],
      );
      await _firestore.collection('doctors').doc(doctor.id).set(doctorModel.toFirestore());
    }

    return users;
  }

  // Generate Service Providers
  Future<List<ServiceProviderModel>> generateServiceProviders() async {
    List<ServiceProviderModel> providers = [];

    // Generate 2 service providers
    for (int i = 0; i < 2; i++) {
      Governorate governorate = _getRandomGovernorate();
      ServiceProviderModel provider = ServiceProviderModel(
        id: _faker.guid.guid(),
        name: _faker.company.name(),
        phoneNumber: _faker.phoneNumber.us(),
        email: _faker.internet.email(),
        governorate: governorateMap[governorate.name]!,
        latitude: governorateMap[governorate.name]!.lat,
        longitude: governorateMap[governorate.name]!.long,
        photo_url: '', // You might want to add a placeholder image URL
        address: _faker.address.streetAddress(),
        description: _faker.lorem.sentence(),
      );
      providers.add(provider);

      // Add service provider to Firestore
      await _firestore.collection('service_providers').doc(provider.id).set(provider.toFirestore());
    }

    return providers;
  }

  // Associate Doctors with Service Providers
  Future<void> associateDoctorsWithServiceProviders(
    List<UserModel> users, 
    List<ServiceProviderModel> serviceProviders
  ) async {
    List<DoctorModel> doctors = [] ;
    for (var user in users){
      if (user.role == Role.DOCTOR){
        final DocumentSnapshot doctorDoc = await _firestore.collection('doctors').doc(user.id).get();
        doctors.add(DoctorModel.fromFirestore( doctorDoc ));
      }
    }
    // Randomly associate doctors with service providers
    for (var doctor in doctors.take(4)) {
      DoctorWorksAtServiceProvider association = DoctorWorksAtServiceProvider(
        doctor: doctor,
        serviceProvider: serviceProviders[_random.nextInt(serviceProviders.length)],
      );
      await _firestore.collection('doctor_works_at_service_provider').add(association.toFirestore());
    }
  }

  // Create Appointments
  Future<void> createAppointments(
    List<UserModel> users, 
    List<ServiceProviderModel> serviceProviders
  ) async {
    List<DoctorModel> doctors = [] ;
    for (var user in users){
      if (user.role == Role.DOCTOR){
        final DocumentSnapshot doctorDoc = await _firestore.collection('doctors').doc(user.id).get();
        doctors.add(DoctorModel.fromFirestore( doctorDoc ));
      }
    }
    List<PatientModel> patients = [];
    for (var user in users){
      if (user.role == Role.PATIENT){
        final DocumentSnapshot patientDoc = await _firestore.collection('patients').doc(user.id).get();
        patients.add(PatientModel.fromFirestore( patientDoc ));
      }
    }

    // Create a few appointments
    for (var patient in patients) {
      AppointmentModel appointment = AppointmentModel(
        patient: patient,
        doctor: doctors[_random.nextInt(doctors.length)],
        serviceProvider: serviceProviders[_random.nextInt(serviceProviders.length)],
        appointmentDate: DateTime.now().add(Duration(days: _random.nextInt(30))),
        appointmentHour: DateTime.now().add(Duration(hours: _random.nextInt(24))),
        mode: AppointmentMode.values[_random.nextInt(AppointmentMode.values.length)],
        status: AppointmentStatus.values[_random.nextInt(AppointmentStatus.values.length)],
      );

      await _firestore.collection('appointments').add({
        'patient_ref': _firestore.collection('patients').doc(patient.user.id),
        'doctor_ref': _firestore.collection('doctors').doc(appointment.doctor.user.id),
        'service_provider_ref': _firestore.collection('service_providers').doc(appointment.serviceProvider!.id),
        'appointment_date': appointment.appointmentDate,
        'appointment_hour': appointment.appointmentHour,
        'mode': appointment.mode.name,
        'status': appointment.status.name,
      });
    }
  }

  // Main method to generate all data
  Future<void> generateData() async {
    try {
      // Generate users
      List<UserModel> users = await generateUsers();

      // Generate service providers
      List<ServiceProviderModel> serviceProviders = await generateServiceProviders();

      // Associate doctors with service providers
      await associateDoctorsWithServiceProviders(users, serviceProviders);

      // Create appointments
      await createAppointments(users, serviceProviders);

      print('Fake data generation completed successfully!');
    } catch (e) {
      print('Error generating fake data: $e');
    }
  }
}

void main() async {
  // Ensure Firebase is initialized before running
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseDataGenerator generator = FirebaseDataGenerator();
  await generator.generateData();
}
