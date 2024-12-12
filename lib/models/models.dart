

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

enum Gender { MALE, FEMALE }

enum Role { DOCTOR, PATIENT, ACCOMMODATION_PROVIDER, CLINIC_AGENT }

enum AccommodationType { HOTEL, APARTMENT, GUEST_HOUSE }

enum AppointmentMode { IN_PLACE, ONLINE }

enum AppointmentStatus { DONE, SCHEDULED, ON_HOLD, CANCELED }

enum Specialties {
  RADIOLOGY,
  CARDIOLOGY,
  DERMATOLOGY,
  NEUROLOGY,
  ONCOLOGY,
  PEDIATRICS,
  PSYCHIATRY,
  GYNECOLOGY,
  ORTHOPEDICS,
  ANESTHESIOLOGY,
  OPHTHALMOLOGY,
  GASTROENTEROLOGY,
  ENDOCRINOLOGY,
  PULMONOLOGY,
  UROLOGY,
  NEPHROLOGY,
  RHEUMATOLOGY,
  PATHOLOGY,
  IMMUNOLOGY,
  HEMATOLOGY,
  GENERAL_PRACTICE,
  OTOLARYNGOLOGY,
  PLASTIC_SURGERY,
  EMERGENCY_MEDICINE,
  FAMILY_MEDICINE,
  SPORTS_MEDICINE
}

enum Governorate {
  Tunis,
  Ariana,
  Ben_Arous,
  Manouba,
  Nabeul,
  Bizerte,
  Beja,
  Jendouba,
  Zaghouan,
  Kairouan,
  Sousse,
  Monastir,
  Mahdia,
  Sfax,
  Gabes,
  Mednine,
  Tataouine,
  Kebili,
  Tozeur,
  Gafsa,
  Kasserine,
  Sidi_Bouzid,
  Siliana,
  Le_Kef
}

const Map<Governorate, LatLng> governorateLatLngMap = {
  Governorate.Tunis: LatLng(36.8065, 10.1815),
  Governorate.Ariana: LatLng(36.8665, 10.1647),
  Governorate.Ben_Arous: LatLng(36.7532, 10.2199),
  Governorate.Manouba: LatLng(36.8101, 10.0956),
  Governorate.Nabeul: LatLng(36.4516, 10.7355),
  Governorate.Bizerte: LatLng(37.2746, 9.8739),
  Governorate.Beja: LatLng(36.7333, 9.1833),
  Governorate.Jendouba: LatLng(36.5011, 8.7802),
  Governorate.Zaghouan: LatLng(36.4022, 10.1422),
  Governorate.Kairouan: LatLng(35.6781, 10.0963),
  Governorate.Sousse: LatLng(35.8256, 10.6362),
  Governorate.Monastir: LatLng(35.7773, 10.8262),
  Governorate.Mahdia: LatLng(35.5047, 11.0622),
  Governorate.Sfax: LatLng(34.7430, 10.7600),
  Governorate.Gabes: LatLng(33.8815, 10.0982),
  Governorate.Mednine: LatLng(33.3540, 10.5055),
  Governorate.Tataouine: LatLng(32.9293, 10.4518),
  Governorate.Kebili: LatLng(33.7077, 8.9725),
  Governorate.Tozeur: LatLng(33.9197, 8.1335),
  Governorate.Gafsa: LatLng(34.4250, 8.7842),
  Governorate.Kasserine: LatLng(35.1674, 8.8323),
  Governorate.Sidi_Bouzid: LatLng(35.0381, 9.4841),
  Governorate.Siliana: LatLng(36.0833, 9.3667),
  Governorate.Le_Kef: LatLng(36.1826, 8.7141),
};

GovernorateModel fallbackGovernorate = GovernorateModel(
  governorate: Governorate.Tunis, // Replace with a sensible default
  lat: 36.8065,
  long: 10.1815,
);

class GovernorateModel {
  final Governorate governorate;
  final double lat;
  final double long;
  final LatLng latlng;
  const GovernorateModel({
    required this.governorate,
    required this.lat,
    required this.long,
    this.latlng = const LatLng(36.8065, 1031815)
  });
}



const Map<String, GovernorateModel> governorateMap = {
  "Tunis": GovernorateModel(governorate: Governorate.Tunis, lat: 36.8065, long: 10.1815, latlng: LatLng(36.8065, 10.1815)),
  "Ariana": GovernorateModel(governorate: Governorate.Ariana, lat: 36.8665, long: 10.1647, latlng: LatLng(36.8665, 10.1647)),
  "Ben_Arous": GovernorateModel(governorate: Governorate.Ben_Arous, lat: 36.7532, long: 10.2199, latlng: LatLng(36.7532, 10.2199)),
  "Manouba": GovernorateModel(governorate: Governorate.Manouba, lat: 36.8101, long: 10.0956, latlng: LatLng(36.8101, 10.0956)),
  "Nabeul": GovernorateModel(governorate: Governorate.Nabeul, lat: 36.4516, long: 10.7355, latlng: LatLng(36.4516, 10.7355)),
  "Bizerte": GovernorateModel(governorate: Governorate.Bizerte, lat: 37.2746, long: 9.8739, latlng: LatLng(37.2746, 9.8739)),
  "Beja": GovernorateModel(governorate: Governorate.Beja, lat: 36.7333, long: 9.1833, latlng: LatLng(36.7333, 9.1833)),
  "Jendouba": GovernorateModel(governorate: Governorate.Jendouba, lat: 36.5011, long: 8.7802, latlng: LatLng(36.5011, 8.7802)),
  "Zaghouan": GovernorateModel(governorate: Governorate.Zaghouan, lat: 36.4022, long: 10.1422, latlng: LatLng(36.4022, 10.1422)),
  "Kairouan": GovernorateModel(governorate: Governorate.Kairouan, lat: 35.6781, long: 10.0963, latlng: LatLng(35.6781, 10.0963)),
  "Sousse": GovernorateModel(governorate: Governorate.Sousse, lat: 35.8256, long: 10.6362, latlng: LatLng(35.8256, 10.6362)),
  "Monastir": GovernorateModel(governorate: Governorate.Monastir, lat: 35.7773, long: 10.8262, latlng: LatLng(35.7773, 10.8262)),
  "Mahdia": GovernorateModel(governorate: Governorate.Mahdia, lat: 35.5047, long: 11.0622, latlng: LatLng(35.5047, 11.0622)),
  "Sfax": GovernorateModel(governorate: Governorate.Sfax, lat: 34.7430, long: 10.7600, latlng: LatLng(34.7430, 10.7600)),
  "Gabes": GovernorateModel(governorate: Governorate.Gabes, lat: 33.8815, long: 10.0982, latlng: LatLng(33.8815, 10.0982)),
  "Mednine": GovernorateModel(governorate: Governorate.Mednine, lat: 33.3540, long: 10.5055, latlng: LatLng(33.3540, 10.5055)),
  "Tataouine": GovernorateModel(governorate: Governorate.Tataouine, lat: 32.9293, long: 10.4518, latlng: LatLng(32.9293, 10.4518)),
  "Kebili": GovernorateModel(governorate: Governorate.Kebili, lat: 33.7077, long: 8.9725, latlng: LatLng(33.7077, 8.9725)),
  "Tozeur": GovernorateModel(governorate: Governorate.Tozeur, lat: 33.9197, long: 8.1335, latlng: LatLng(33.9197, 8.1335)),
  "Gafsa": GovernorateModel(governorate: Governorate.Gafsa, lat: 34.4250, long: 8.7842, latlng: LatLng(34.4250, 8.7842)),
  "Kasserine": GovernorateModel(governorate: Governorate.Kasserine, lat: 35.1674, long: 8.8323, latlng: LatLng(35.1674, 8.8323)),
  "Sidi_Bouzid": GovernorateModel(governorate: Governorate.Sidi_Bouzid, lat: 35.0381, long: 9.4841, latlng: LatLng(35.0381, 9.4841)),
  "Siliana": GovernorateModel(governorate: Governorate.Siliana, lat: 36.0833, long: 9.3667, latlng: LatLng(36.0833, 9.3667)),
  "Le_Kef": GovernorateModel(governorate: Governorate.Le_Kef, lat: 36.1826, long: 8.7141, latlng: LatLng(36.1826, 8.7141)),
};


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
    this.profilePicture = "https://cdn.pixabay.com/photo/2023/10/03/10/49/anonymous-8291223_960_720.png",
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
      'profile_picture': profilePicture ?? "https://cdn.pixabay.com/photo/2023/10/03/10/49/anonymous-8291223_960_720.png",
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
    this.medicalHistory =  "medicalHistory",
    this.feedback =  "feedback",
  });

  Map<String, dynamic> toFirestore() {
    return {
      'username': user.username,
      'cin': user.cin,
      'birthday': user.birthday.toString(),
      'gender': user.gender.name,
      'profile_picture': user.profilePicture,
      'phone_number': user.phoneNumber,
      'role': user.role.name,
      'medicalHistory': medicalHistory,
      'feedback': feedback,
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
  final Specialties speciality;
  final int experienceYears;
  final double recommendationRate;
  final String address;
  final GovernorateModel governorate ;

  DoctorModel({
    required this.user,
    this.consultationFee = 70.0,
    this.speciality = Specialties.GENERAL_PRACTICE,
    this.experienceYears = 1,
    this.recommendationRate = 0.0,
    this.address = 'tunis,tunis',
    GovernorateModel? governorate,
  }) : this.governorate = governorate ?? governorateMap["Tunis"]!;


  factory DoctorModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return DoctorModel(
      user: UserModel.fromFirestore(doc),
      consultationFee: data['consultation_fee'] ?? 70.0,
      speciality: Specialties.values.byName(data['speciality']) ??
          Specialties.GENERAL_PRACTICE,
      experienceYears: data['experience_years'] ?? 1,
      recommendationRate: data['recommendation_rate'] ?? 0.0,
      address: data['address'] ?? 'tunis,tunis',
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      'username': user.username,
      'cin': user.cin,
      'birthday': user.birthday.toString(),
      'gender': user.gender.name,
      'profile_picture': user.profilePicture,
      'phone_number': user.phoneNumber,
      'role': user.role.name,
      'consultationFee': consultationFee,
      'speciality': speciality.name,
      'experienceYears': experienceYears,
      'recommendationRate': recommendationRate,
      'address': address,
      'governorate' : governorate.governorate.name,
    };
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
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final GovernorateModel governorate;
  final double latitude ;
  final double longitude;
  final String photo_url;
  final String address;
  
  final String description;

  ServiceProviderModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    this.latitude = 36.8065, 
    this.longitude = 10.1815,
    required this.photo_url,

    this.description = "nothing to display",
    required this.address,
    GovernorateModel? governorate,
}) : this.governorate = governorate ?? governorateMap["Tunis"]!;

  factory ServiceProviderModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    String? governorateKey = data['governorate'];
    GovernorateModel governorateModel =
        governorateMap[governorateKey] ?? fallbackGovernorate;
    return ServiceProviderModel(
      id: doc.id,
      name: data['name'],
      phoneNumber: data['phone_number'],
      email: data['email'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      photo_url: data['photo_url'],
      governorate: governorateModel,
      address: data['address'],
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'phone_number': phoneNumber,
      'email': email,
      'latitude': latitude,
      'longitude': longitude,
      'photo_url': photo_url,
      'governorate': governorate.governorate.name,
    };
  }
}

//doctor and service provider association
class DoctorWorksAtServiceProvider {
  final DoctorModel doctor;
  final ServiceProviderModel serviceProvider;
  DoctorWorksAtServiceProvider({
    required this.doctor,
    required this.serviceProvider,
  });

  static Future<DoctorWorksAtServiceProvider> fromFirestore(
      DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;

    // Fetch doctor and service provider data using their references
    final doctorRef = data['doctor_ref'] as DocumentReference;
    final serviceProviderRef =
        data['service_provider_ref'] as DocumentReference;

    final doctorSnapshot = await doctorRef.get();
    final serviceProviderSnapshot = await serviceProviderRef.get();

    return DoctorWorksAtServiceProvider(
        doctor: DoctorModel.fromFirestore(doctorSnapshot),
        serviceProvider:
            ServiceProviderModel.fromFirestore(serviceProviderSnapshot));
  }

  Map<String, dynamic> toFirestore() {
    return {
      'doctor_ref': doctor.user.id,
      'service_provider_ref': serviceProvider.id,
    };
  }
}

class FavoritsDoctorsModel {
  final List<DoctorModel> listOfFavDoctors;
  final PatientModel patient;

  FavoritsDoctorsModel({
    required this.patient,
    this.listOfFavDoctors = const [],
  });

  /// Creates an instance of `FavoritsDoctorsModel` from Firestore data
  static Future<FavoritsDoctorsModel> fromFirestore(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;

    // Fetch patient data using their reference
    final patientRef = data['patient_ref'] as DocumentReference;
    final patientSnapshot = await patientRef.get();
    final patient = PatientModel.fromFirestore(patientSnapshot);

    // Fetch list of favorite doctors
    final List<dynamic> doctorRefs = data['list_of_fav_doctors'] ?? [];
    final List<DoctorModel> favDoctors = [];
    for (final docRef in doctorRefs) {
      final doctorSnapshot = await (docRef as DocumentReference).get();
      favDoctors.add(DoctorModel.fromFirestore(doctorSnapshot));
    }

    return FavoritsDoctorsModel(
      patient: patient,
      listOfFavDoctors: favDoctors,
    );
  }

  /// Converts `FavoritsDoctorsModel` to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'patient_ref': patient.user.id,
      'list_of_fav_doctors': listOfFavDoctors.map((doctor) => doctor.user.id).toList(),
    };
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
    final serviceProviderRef =
        data['service_provider_ref'] as DocumentReference;

    final patientSnapshot = await patientRef.get();
    final doctorSnapshot = await doctorRef.get();
    final serviceProviderSnapshot = await serviceProviderRef.get();

    return AppointmentModel(
      patient: PatientModel.fromFirestore(patientSnapshot),
      doctor: DoctorModel.fromFirestore(doctorSnapshot),
      serviceProvider:
          ServiceProviderModel.fromFirestore(serviceProviderSnapshot),
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
  final RxList<AccommodationModel> accommodations =
      RxList<AccommodationModel>();
  final RxList<AppointmentModel> appointments = RxList<AppointmentModel>();
  final RxList<ServiceProviderModel> service_providers =
      RxList<ServiceProviderModel>();
  final RxList<DoctorWorksAtServiceProvider> doctorWorksAtServiceProviders =
      RxList<DoctorWorksAtServiceProvider>();
  bool isDataFetched = false;

  // Firestore References
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch and populate data methods
  Future<void> fetchAllData() async {
    await fetchDoctors();
    await fetchAccommodations();
    await fetchAppointments();
    await fetchServiceProviders();
    await fetchDoctorWorksAtServiceProvider();
    isDataFetched = true;
  }

  Future<void> fetchDoctors() async {
    QuerySnapshot querySnapshot = await _firestore.collection('doctors').get();
    doctors.value = querySnapshot.docs
        .map((doc) => DoctorModel.fromFirestore(doc))
        .toList();
  }

  Future<void> fetchServiceProviders() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('service_providers').get();
    service_providers.value = querySnapshot.docs
        .map((doc) => ServiceProviderModel.fromFirestore(doc))
        .toList();
  }

  Future<void> fetchDoctorWorksAtServiceProvider() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('doctor_works_at_service_provider').get();
    doctorWorksAtServiceProviders.value = querySnapshot.docs
        .map((doc) => DoctorWorksAtServiceProvider.fromFirestore(doc))
        .cast<DoctorWorksAtServiceProvider>()
        .toList();
  }

  Future<void> fetchAccommodations() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('accommodations').get();
    accommodations.value = querySnapshot.docs
        .map((doc) => AccommodationModel.fromFirestore(doc))
        .toList();
  }

  Future<void> fetchAppointments() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('appointments').get();
    List<AppointmentModel> appointmentsList = [];
    for (var doc in querySnapshot.docs) {
      appointmentsList.add(await AppointmentModel.fromFirestore(doc));
    }
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