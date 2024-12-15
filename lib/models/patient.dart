part of "models.dart";
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
  final ServiceProviderModel? serviceProvider;
  final DateTime appointmentDate;
  final DateTime appointmentHour;
  final AppointmentMode mode;
  final AppointmentStatus status;

  AppointmentModel({
    required this.patient,
    required this.doctor,
    this.serviceProvider,
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
    // final serviceProviderRef = data['service_provider_ref'] as DocumentReference;

    final patientSnapshot = await patientRef.get();
    final doctorSnapshot = await doctorRef.get();


    final patient = PatientModel.fromFirestore(patientSnapshot) ;
    final doctor = DoctorModel.fromFirestore(doctorSnapshot);
    // final serviceProviderSnapshot = await serviceProviderRef.get();


    return AppointmentModel(
      patient: patient,
      doctor: doctor,
      // serviceProvider: ServiceProviderModel.fromFirestore(serviceProviderSnapshot),
      appointmentDate: (data['appointment_date'] as Timestamp).toDate(),
      appointmentHour: (data['appointment_hour'] as Timestamp).toDate(),
      mode: AppointmentMode.values.byName(data['mode']),
      status: AppointmentStatus.values.byName(data['status']),
    );
  }
  Future<Map<String, dynamic>>  toFirestore() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    final DocumentSnapshot doctorDoc = await _firestore.collection('doctors').doc(doctor.user.id).get();
    final DocumentSnapshot patientDoc = await _firestore.collection('patients').doc(patient.user.id).get();
    // final DocumentSnapshot serviceProviderDoc = await _firestore.collection('doctors').doc(doctor.user.id).get();
    // Fetch patient and doctor data using their references

    final patientRef =  patientDoc.reference;
    final doctorRef = doctorDoc.reference;
    // final serviceProviderRef = serviceProviderDoc.reference;
    return {
      'patient_ref': patientRef,
      'doctor_ref': doctorRef,
      'service_provider_ref': serviceProvider,
      'appointment_date': appointmentDate,
      'appointment_hour': appointmentHour,
      'mode': mode.name,
      'status': status.name,
    };
  }



}
