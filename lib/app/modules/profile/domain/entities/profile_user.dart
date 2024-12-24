import 'package:connect/app/modules/auth/domain/entities/app_user.dart';

class ProfileUser extends AppUser {
  final int pTotal;
  final int pSpent;
  final int pCurrent;

  final String profilePictureUrl;
  final String phoneNumber;
  final String role;
  final DateTime entryDate;
  final DateTime birthday;

  final String linkedinUrl;
  final String instagramUrl;
  final String facebookUrl;

  ProfileUser({
    required super.uid,
    required super.email,
    required super.name,
    required this.pTotal,
    required this.pSpent,
    required this.pCurrent,
    required this.profilePictureUrl,
    required this.phoneNumber,
    required this.role,
    required this.entryDate,
    required this.birthday,
    required this.linkedinUrl,
    required this.instagramUrl,
    required this.facebookUrl,
  });

  ProfileUser updateStore({int? newPTotal, int? newPSpent, int? newPCurrent}) {
    return ProfileUser(
      uid: uid,
      email: email,
      name: name,
      pTotal: newPTotal ?? pTotal,
      pSpent: newPSpent ?? pSpent,
      pCurrent: newPCurrent ?? pCurrent,
      profilePictureUrl: profilePictureUrl,
      phoneNumber: phoneNumber,
      role: role,
      entryDate: entryDate,
      birthday: birthday,
      linkedinUrl: linkedinUrl,
      instagramUrl: instagramUrl,
      facebookUrl: facebookUrl,
    );
  }

  ProfileUser updateData({
    String? newProfilePictureUrl,
    String? newLinkedinUrl,
    String? newInstagramUrl,
    String? newFacebookUrl,
  }) {
    return ProfileUser(
      uid: uid,
      email: email,
      name: name,
      pTotal: pTotal,
      pSpent: pSpent,
      pCurrent: pCurrent,
      profilePictureUrl: newProfilePictureUrl ?? profilePictureUrl,
      phoneNumber: phoneNumber,
      role: role,
      entryDate: entryDate,
      birthday: birthday,
      linkedinUrl: newLinkedinUrl ?? linkedinUrl,
      instagramUrl: newInstagramUrl ?? instagramUrl,
      facebookUrl: newFacebookUrl ?? facebookUrl,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'pTotal': pTotal,
      'pSpent': pSpent,
      'pCurrent': pCurrent,
      'profilePictureUrl': profilePictureUrl,
      'phoneNumber': phoneNumber,
      'role': role,
      'entryDate': entryDate,
      'birthday': birthday,
      'linkedinUrl': linkedinUrl,
      'instagramUrl': instagramUrl,
      'facebookUrl': facebookUrl,
    };
  }

  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
      uid: json['uid'],
      email: json['email'],
      name: json['name'],
      pTotal: json['pTotal'] ?? 0,
      pSpent: json['pSpent'] ?? 0,
      pCurrent: json['pCurrent'] ?? 0,
      profilePictureUrl: json['profilePictureUrl'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      role: json['role'] ?? '',
      entryDate: json['entryDate'],
      birthday: json['birthday'],
      linkedinUrl: json['linkedinUrl'] ?? '',
      instagramUrl: json['instagramUrl'] ?? '',
      facebookUrl: json['facebookUrl'] ?? '',
    );
  }

factory ProfileUser.fromMap(Map<String, dynamic> map) {
  return ProfileUser(
    uid: map['uid'] ?? '',  
    email: map['email'] ?? '',
    name: map['name'] ?? '',
    pTotal: map['pTotal'] ?? 0,
    pSpent: map['pSpent'] ?? 0,
    pCurrent: map['pCurrent'] ?? 0,
    profilePictureUrl: map['profilePictureUrl'] ?? '',
    phoneNumber: map['phoneNumber'] ?? '',
    role: map['role'] ?? '',
    entryDate: DateTime.tryParse(map['entryDate'] ?? '') ?? DateTime.now(),
    birthday: DateTime.tryParse(map['birthday'] ?? '') ?? DateTime.now(),
    linkedinUrl: map['linkedinUrl'] ?? '',
    instagramUrl: map['instagramUrl'] ?? '',
    facebookUrl: map['facebookUrl'] ?? '',
  );
}

}
