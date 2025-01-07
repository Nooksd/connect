import 'package:connect/app/modules/auth/domain/entities/app_user.dart';

class ProfileUser extends AppUser {
  final int pTotal;
  final int pSpent;
  final int pCurrent;

  final String phoneNumber;
  final String email;
  final DateTime entryDate;
  final DateTime birthday;

  final String linkedinUrl;
  final String instagramUrl;
  final String facebookUrl;

  ProfileUser({
    required super.uid,
    required super.name,
    required super.role,
    required super.profilePictureUrl,
    required this.email,
    required this.pTotal,
    required this.pSpent,
    required this.pCurrent,
    required this.phoneNumber,
    required this.entryDate,
    required this.birthday,
    required this.linkedinUrl,
    required this.instagramUrl,
    required this.facebookUrl,
  });

  ProfileUser updateData({
    String? newProfilePictureUrl,
    String? newLinkedinUrl,
    String? newInstagramUrl,
    String? newFacebookUrl,
    String? newRole,
  }) {
    return ProfileUser(
      uid: uid,
      email: email,
      name: name,
      role: newRole ?? role,
      profilePictureUrl: newProfilePictureUrl ?? profilePictureUrl,
      pTotal: pTotal,
      pSpent: pSpent,
      pCurrent: pCurrent,
      phoneNumber: phoneNumber,
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
      'phoneNumber': phoneNumber,
      'entryDate': entryDate.toIso8601String(),
      'birthday': birthday.toIso8601String(),
      'linkedinUrl': linkedinUrl,
      'instagramUrl': instagramUrl,
      'facebookUrl': facebookUrl,
    };
  }

  factory ProfileUser.fromMap(Map<String, dynamic> map) {
    return ProfileUser(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: map['role'],
      profilePictureUrl: map['profilePictureUrl'],
      pTotal: map['pTotal'] ?? 0,
      pSpent: map['pSpent'] ?? 0,
      pCurrent: map['pCurrent'] ?? 0,
      phoneNumber: map['phoneNumber'] ?? '',
      entryDate: map['entryDate'] != null
          ? (map['entryDate'] is int
              ? DateTime.fromMillisecondsSinceEpoch(map['entryDate'] * 1000)
              : DateTime.parse(map['entryDate']))
          : DateTime.fromMillisecondsSinceEpoch(0),
      birthday: map['birthday'] != null
          ? (map['birthday'] is int
              ? DateTime.fromMillisecondsSinceEpoch(map['birthday'] * 1000)
              : DateTime.parse(map['birthday']))
          : DateTime.fromMillisecondsSinceEpoch(0),
      linkedinUrl: map['linkedinUrl'] ?? '',
      instagramUrl: map['instagramUrl'] ?? '',
      facebookUrl: map['facebookUrl'] ?? '',
    );
  }
}
