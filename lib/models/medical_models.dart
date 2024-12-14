part of "models.dart";
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
    this.experienceYears =1,
    this.recommendationRate = 0.0,
    this.address = 'tunis,tunis',
    GovernorateModel? governorate,
  }) : this.governorate = governorate ?? governorateMap["Tunis"]!;


  factory DoctorModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    DoctorModel doctor = DoctorModel(
      user: UserModel.fromFirestore(doc),
      consultationFee: data['consultation_fee'] ?? 70.0,
      speciality: Specialties.values.byName(data['speciality']) ??
          Specialties.GENERAL_PRACTICE,
      experienceYears: data['experienceYears']?? 1 ,
      recommendationRate: data['recommendation_rate'] ?? 0.0,
      address: data['address'] ?? 'tunis,tunis',
    );
    return doctor;
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
