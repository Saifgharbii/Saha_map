part of 'models.dart';

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

GovernorateModel fallbackGovernorate = const GovernorateModel(
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
