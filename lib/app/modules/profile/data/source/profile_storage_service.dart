import 'dart:convert';

import 'package:connect/app/core/services/database/my_local_storage.dart';

class ProfileStorageService {
  final MyLocalStorage localStorage;

  ProfileStorageService({required this.localStorage});

  Future<String?> getUser() async {
    return await localStorage.get('user');
  }

  Future<void> setuser(Map<String, dynamic> user) async {
    await localStorage.set('user', jsonEncode(user));
  }
}
