import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

// Enums mirroring Django model choices
enum Gender { MALE, FEMALE }
enum Role { DOCTOR, PATIENT, HOSPITAL_AGENT, ACCOMMODATION_PROVIDER, CLINIC_AGENT }
enum AccommodationType { HOTEL, APARTMENT, GUEST_HOUSE }
enum AppointmentMode { IN_PLACE, ONLINE }
enum AppointmentStatus { DONE, SCHEDULED, ON_HOLD, CANCELED }

// User Model
class UserModel {
  final String id;
  final String username;
  final int cin;
  final DateTime birthday;
  final Gender gender;
  final String? profilePicture;
  final String phoneNumber;
  final Role role;

  UserModel({
    required this.id,
    required this.username,
    required this.cin,
    required this.birthday,
    required this.gender,
    this.profilePicture,
    required this.phoneNumber,
    required this.role,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      username: data['username'] ?? '',
      cin: data['cin'],
      birthday: (data['birthday'] as Timestamp).toDate(),
      gender: Gender.values.byName(data['gender']),
      profilePicture: data['profile_picture'],
      phoneNumber: data['phone_number'],
      role: Role.values.byName(data['role']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'username': username,
      'cin': cin,
      'birthday': birthday,
      'gender': gender.name,
      'profile_picture': profilePicture,
      'phone_number': phoneNumber,
      'role': role.name,
    };
  }
}

// Patient Model
class PatientModel {
  final UserModel user;
  final String? medicalHistory;
  final String? feedback;

  PatientModel({
    required this.user,
    this.medicalHistory,
    this.feedback,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'username': user.username,
      'cin': user.cin,
      'birthday': user.birthday,
      'gender': user.gender.name,
      'profile_picture': user.profilePicture,
      'phone_number': user.phoneNumber,
      'role': user.role.name,
      'medicalHistory' : medicalHistory,
      'feedback' : feedback,
    };
  }

  factory PatientModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PatientModel(
      user: UserModel.fromFirestore(doc),
      medicalHistory: data['medical_history'],
      feedback: data['feedback'],
    );
  }
}

// Doctor Model
class DoctorModel {
  final UserModel user;
  final double consultationFee;
  final String speciality;
  final int experienceYears;
  final double recommendationRate;

  DoctorModel({
    required this.user,
    required this.consultationFee,
    required this.speciality,
    required this.experienceYears,
    required this.recommendationRate,
  });

  factory DoctorModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return DoctorModel(
      user: UserModel.fromFirestore(doc),
      consultationFee: data['consultation_fee'],
      speciality: data['speciality'],
      experienceYears: data['experience_years'],
      recommendationRate: data['recommendation_rate'],
    );
  }
}

// Accommodation Model
class AccommodationModel {
  final UserModel provider;
  final double latitude;
  final double longitude;
  final AccommodationType type;
  final int roomsNumber;
  final String description;
  final List<String> photos;
  final bool availability;
  final double nightPrice;
  final double rate;

  AccommodationModel({
    required this.provider,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.roomsNumber,
    required this.description,
    required this.photos,
    required this.availability,
    required this.nightPrice,
    required this.rate,
  });

  factory AccommodationModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AccommodationModel(
      provider: UserModel.fromFirestore(doc),
      latitude: data['latitude'],
      longitude: data['longitude'],
      type: AccommodationType.values.byName(data['type']),
      roomsNumber: data['rooms_number'],
      description: data['description'],
      photos: List<String>.from(data['photos']),
      availability: data['availability'],
      nightPrice: data['night_price'],
      rate: data['rate'],
    );
  }
}

// Service Provider Model
class ServiceProviderModel {
  final String name;
  final String phoneNumber;
  final String email;
  final double latitude;
  final double longitude;
  final String type;

  ServiceProviderModel({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.latitude,
    required this.longitude,
    required this.type,
  });

  factory ServiceProviderModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ServiceProviderModel(
      name: data['name'],
      phoneNumber: data['phone_number'],
      email: data['email'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      type: data['type'],
    );
  }
}

// Appointment Model
class AppointmentModel {
  final PatientModel patient;
  final DoctorModel doctor;
  final ServiceProviderModel serviceProvider;
  final DateTime appointmentDate;
  final DateTime appointmentHour;
  final AppointmentMode mode;
  final AppointmentStatus status;

  AppointmentModel({
    required this.patient,
    required this.doctor,
    required this.serviceProvider,
    required this.appointmentDate,
    required this.appointmentHour,
    required this.mode,
    required this.status,
  });

  static Future<AppointmentModel> fromFirestore(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;

    // Fetch patient and doctor data using their references
    final patientRef = data['patient_ref'] as DocumentReference;
    final doctorRef = data['doctor_ref'] as DocumentReference;
    final serviceProviderRef = data['service_provider_ref'] as DocumentReference;


    final patientSnapshot = await patientRef.get();
    final doctorSnapshot = await doctorRef.get();
    final serviceProviderSnapshot = await serviceProviderRef.get();


    return AppointmentModel(
      patient: PatientModel.fromFirestore(patientSnapshot),
      doctor: DoctorModel.fromFirestore(doctorSnapshot),
      serviceProvider: ServiceProviderModel.fromFirestore(serviceProviderSnapshot),
      appointmentDate: (data['appointment_date'] as Timestamp).toDate(),
      appointmentHour: (data['appointment_hour'] as Timestamp).toDate(),
      mode: AppointmentMode.values.byName(data['mode']),
      status: AppointmentStatus.values.byName(data['status']),
    );
  }

}

// Global Controller for State Management
class GlobalController extends GetxController {
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxList<DoctorModel> doctors = RxList<DoctorModel>();
  final RxList<AccommodationModel> accommodations = RxList<AccommodationModel>();
  final RxList<AppointmentModel> appointments = RxList<AppointmentModel>();
  bool isDataFetched = false;

  // Firestore References
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch and populate data methods
  Future<void> fetchAllData() async {
    await fetchDoctors();
    await fetchAccommodations();
    await fetchAppointments();
    isDataFetched = true;
  }

  Future<void> fetchDoctors() async {
    QuerySnapshot querySnapshot = await _firestore.collection('doctors').get();
    doctors.value = querySnapshot.docs
        .map((doc) => DoctorModel.fromFirestore(doc))
        .toList();
    print(doctors);
  }

  Future<void> fetchAccommodations() async {
    QuerySnapshot querySnapshot = await _firestore.collection('accommodations').get();
    accommodations.value = querySnapshot.docs
        .map((doc) => AccommodationModel.fromFirestore(doc))
        .toList();
  }

  Future<void> fetchAppointments() async {
    QuerySnapshot querySnapshot = await _firestore.collection('appointments').get();
    List<AppointmentModel> appointmentsList = [];
    for (var doc in querySnapshot.docs) {
      print(doc.id);
      appointmentsList.add(await AppointmentModel.fromFirestore(doc));
    }
    print("Appointments: $appointmentsList");
    appointments.value = appointmentsList;
  }

  // Helper method to get current user
  UserModel? get getCurrentUser => currentUser.value;

  // Method to set current user
  void setCurrentUser(UserModel user) {
    currentUser.value = user;
  }

  // Singleton pattern to access GlobalController from anywhere
  static GlobalController get to => Get.find();
}

// Usage in any page:
// GlobalController globalController = GlobalController.to;
// var currentUser = globalController.getCurrentUser;