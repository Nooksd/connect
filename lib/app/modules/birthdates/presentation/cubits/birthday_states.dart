import 'package:connect/app/modules/birthdates/domain/entities/birthday.dart';

abstract class BirthdayState {
  get birthdays => null;
}

class BirthdayInitial extends BirthdayState {}

class BirthdayLoading extends BirthdayState {}

class BirthdaysLoaded extends BirthdayState {
  @override
  final List<Birthday> birthdays;

  BirthdaysLoaded(this.birthdays);
}

class BirthdayError extends BirthdayState {
  final String message;

  BirthdayError(this.message);
}
