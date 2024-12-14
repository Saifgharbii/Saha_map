part of "models.dart";

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
