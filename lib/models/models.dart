import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

part 'user_model.dart';
part 'initializers.dart';
part 'medical_models.dart';
part 'accommodation_model.dart';
part 'patient.dart';


// Global Controller for State Management
class GlobalController extends GetxController {
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxList<DoctorModel> doctors = RxList<DoctorModel>();
  final RxList<AccommodationModel> accommodations = RxList<AccommodationModel>();
  final RxList<AppointmentModel> appointments = RxList<AppointmentModel>();
  final RxList<ServiceProviderModel> service_providers = RxList<ServiceProviderModel>();
  final RxList<DoctorWorksAtServiceProvider> doctorWorksAtServiceProviders = RxList<DoctorWorksAtServiceProvider>();
  bool isDataFetched = false;

  // Firestore References
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch and populate data methods
  Future<void> fetchAllData() async {
    print("start fetching") ;
    await fetchDoctors();
    print("fetchDoctors done") ;
    await fetchServiceProviders();
    print("fetchServiceProviders done") ;
    // await fetchAccommodations();
    // print("accomodation done") ;
    await fetchAppointments();
    print("fetch Appointments done") ;
    await fetchDoctorWorksAtServiceProvider();
    print("All data is fetched") ;
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
    QuerySnapshot querySnapshot = await _firestore.collection('doctor_works_at_service_provider').get();
    List<DoctorWorksAtServiceProvider> doctorWorksAtServiceProviderList = [];
    for (var doc in querySnapshot.docs) {
      doctorWorksAtServiceProviderList.add(await DoctorWorksAtServiceProvider.fromFirestore(doc));
    }
    doctorWorksAtServiceProviders.value = doctorWorksAtServiceProviderList;
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