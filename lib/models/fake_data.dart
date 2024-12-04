import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'dart:math';

import 'models.dart';

class TestDataGenerator {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _random = Random();
  final _faker = Faker();

  // Helper method to generate random enum values
  T getRandomEnumValue<T>(List<T> values) => values[_random.nextInt(values.length)];

  // Generate random date within a range
  DateTime getRandomDate({required int startYear, required int endYear}) {
    return DateTime(
      startYear + _random.nextInt(endYear - startYear),
      1 + _random.nextInt(12),
      1 + _random.nextInt(28),
    );
  }

  // Generate fake user data
  Map<String, dynamic> generateUserData(Role role) {
    return {
      'username': _faker.person.name(),
      'cin': 10000000 + _random.nextInt(90000000),
      'birthday': getRandomDate(startYear: 1960, endYear: 2000),
      'gender': getRandomEnumValue(Gender.values).name,
      'profile_picture': _faker.image.loremPicsum(width: 200, height: 200),
      'phone_number': '+216${_random.nextInt(10000000) + 90000000}',
      'role': role.name,
    };
  }

  // Generate fake doctor data
  Future<DocumentReference> generateDoctor() async {
    final userData = generateUserData(Role.DOCTOR);
    final doctorRef = await _firestore.collection('doctors').add(userData);

    await doctorRef.update({
      'consultation_fee': 50.0 + _random.nextInt(150),
      'speciality': _faker.job.title(),
      'experience_years': 1 + _random.nextInt(30),
      'recommendation_rate': _random.nextDouble() * 5,
    });

    return doctorRef;
  }

  // Generate fake patient data
  Future<DocumentReference> generatePatient() async {
    final userData = generateUserData(Role.PATIENT);
    final patientRef = await _firestore.collection('patients').add(userData);

    await patientRef.update({
      'medical_history': _faker.lorem.sentences(3).join(' '),
      'feedback': _random.nextBool() ? _faker.lorem.sentence() : null,
    });

    return patientRef;
  }

  // Generate fake accommodation data
  Future<DocumentReference> generateAccommodation() async {
    final providerData = generateUserData(Role.ACCOMMODATION_PROVIDER);
    final accommodationRef = await _firestore.collection('accommodations').add(providerData);

    await accommodationRef.update({
      'latitude': 36.8065 + (_random.nextDouble() * 0.1),  // Tunisia coordinates
      'longitude': 10.1815 + (_random.nextDouble() * 0.1),
      'type': getRandomEnumValue(AccommodationType.values).name,
      'rooms_number': 1 + _random.nextInt(5),
      'description': _faker.lorem.sentences(2).join(' '),
      'photos': List.generate(3, (index) => _faker.image.loremPicsum(width: 800, height: 600)),
      'availability': _random.nextBool(),
      'night_price': 50.0 + _random.nextInt(200),
      'rate': _random.nextDouble() * 5,
    });

    return accommodationRef;
  }

  // Generate fake service provider data
  Future<DocumentReference> generateServiceProvider() async {
    final serviceProviderRef = await _firestore.collection('service_providers').add({
      'name': _faker.company.name(),
      'phone_number': '+216${_random.nextInt(10000000) + 90000000}',
      'email': _faker.internet.email(),
      'latitude': 36.8065 + (_random.nextDouble() * 0.1),
      'longitude': 10.1815 + (_random.nextDouble() * 0.1),
      'type': _random.nextBool() ? 'HOSPITAL' : 'CLINIC',
    });

    return serviceProviderRef;
  }

  // Generate fake appointment data
  Future<void> generateAppointment(
      DocumentReference patientRef,
      DocumentReference doctorRef,
      DocumentReference serviceProviderRef,
      ) async {
    final now = DateTime.now();
    final appointmentDate = now.add(Duration(days: _random.nextInt(30)));

    await _firestore.collection('appointments').add({
      'patient_ref': patientRef,
      'doctor_ref': doctorRef,
      'service_provider_ref': serviceProviderRef,
      'appointment_date': appointmentDate,
      'appointment_hour': DateTime(
        appointmentDate.year,
        appointmentDate.month,
        appointmentDate.day,
        8 + _random.nextInt(10),
        _random.nextInt(4) * 15,
      ),
      'mode': getRandomEnumValue(AppointmentMode.values).name,
      'status': getRandomEnumValue(AppointmentStatus.values).name,
    });
  }

  // Main function to generate all test data
  Future<void> generateTestData({
    int numberOfDoctors = 10,
    int numberOfPatients = 20,
    int numberOfAccommodations = 15,
    int numberOfServiceProviders = 5,
    int numberOfAppointments = 30,
  }) async {
    print('Starting test data generation...');

    // Generate doctors
    print('Generating doctors...');
    final doctors = await Future.wait(
        List.generate(numberOfDoctors, (index) => generateDoctor())
    );

    // Generate patients
    print('Generating patients...');
    final patients = await Future.wait(
        List.generate(numberOfPatients, (index) => generatePatient())
    );

    // Generate accommodations
    print('Generating accommodations...');
    await Future.wait(
        List.generate(numberOfAccommodations, (index) => generateAccommodation())
    );

    // Generate service providers
    print('Generating service providers...');
    final serviceProviders = await Future.wait(
        List.generate(numberOfServiceProviders, (index) => generateServiceProvider())
    );

    // Generate appointments
    print('Generating appointments...');
    for (int i = 0; i < numberOfAppointments; i++) {
      await generateAppointment(
        patients[_random.nextInt(patients.length)],
        doctors[_random.nextInt(doctors.length)],
        serviceProviders[_random.nextInt(serviceProviders.length)],
      );
    }

    print('Test data generation completed!');
  }
}

// Usage example:
void main() async {
  final generator = TestDataGenerator();
  await generator.generateTestData();
}