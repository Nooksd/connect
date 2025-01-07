import 'package:connect/app/modules/birthdates/domain/entities/birthday.dart';

abstract class BirthdayRepo {
  Future<List<Birthday>> getBirthdays();
}
