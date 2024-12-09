import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/features/profile/domain/entities/profile_user.dart';
import 'package:connect/features/profile/domain/repos/profile_repo.dart';

class FirebaseProfileRepo implements ProfileRepo {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async {
    try {
      final userDoc =
          await firebaseFirestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data();

        if (userData != null) {
          return ProfileUser(
            uid: uid,
            email: userData['email'],
            name: userData['name'],
            pTotal: userData['pTotal'] ?? 0,
            pSpent: userData['pSpent'] ?? 0,
            pCurrent: userData['pCurrent'] ?? 0,
            profilePictureUrl: userData['profilePictureUrl'].toString(),
            phoneNumber: userData['phoneNumber'] ?? '',
            position: userData['position'] ?? '',
            entryDate: userData['entryDate'] ?? '',
            birthday: userData['birthday'] ?? '',
            linkedinUrl: userData['linkedinUrl'].toString(),
            instagramUrl: userData['instagramUrl'].toString(),
            facebookUrl: userData['facebookUrl'].toString(),
          );
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateUserProfile(ProfileUser updatedProfileUser) async {
    try {
      firebaseFirestore.collection('users').doc(updatedProfileUser.uid).update({
        'profilePictureUrl': updatedProfileUser.profilePictureUrl,
        'phoneNumber': updatedProfileUser.phoneNumber,
        'linkedinUrl': updatedProfileUser.linkedinUrl,
        'instagramUrl': updatedProfileUser.instagramUrl,
        'facebookUrl': updatedProfileUser.facebookUrl,
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> updateCoins(ProfileUser updatedProfileUser) async {
    try {
      firebaseFirestore.collection('users').doc(updatedProfileUser.uid).update({
        'pTotal': updatedProfileUser.pTotal,
        'pSpent': updatedProfileUser.pSpent,
        'pCurrent': updatedProfileUser.pCurrent,
      });
    } catch (e) {
      throw Exception(e);
    }
  }
}
