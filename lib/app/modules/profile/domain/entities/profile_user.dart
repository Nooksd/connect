import 'package:connect/app/modules/auth/domain/entities/app_user.dart';

class ProfileUser extends AppUser {
  final int pTotal;
  final int pSpent;
  final int pCurrent;

  final String profilePictureUrl;
  final String phoneNumber;
  final String position;
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
    required this.position,
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
      position: position,
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
      position: position,
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
      'position': position,
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
      position: json['position'] ?? '',
      entryDate: json['entryDate'],
      birthday: json['birthday'],
      linkedinUrl: json['linkedinUrl'] ?? '',
      instagramUrl: json['instagramUrl'] ?? '',
      facebookUrl: json['facebookUrl'] ?? '',
    );
  }
}