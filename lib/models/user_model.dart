part of "models.dart";

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
      'id' : id,
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
