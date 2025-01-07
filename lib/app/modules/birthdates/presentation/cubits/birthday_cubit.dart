import 'package:connect/app/modules/birthdates/domain/repos/birthday_repo.dart';
import 'package:connect/app/modules/birthdates/presentation/cubits/birthday_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BirthdayCubit extends Cubit<BirthdayState> {
  final BirthdayRepo birthdayRepo;
  double scrollPosition = 0.0;
  int pageIndex = 1;

  BirthdayCubit({required this.birthdayRepo}) : super(BirthdayInitial());

  Future<void> getBirthdays() async {
    emit(BirthdayLoading());

    try {
      final birthdays = await birthdayRepo.getBirthdays();

      if (birthdays.isNotEmpty) {
        emit(BirthdaysLoaded(birthdays));
      } else {
        emit(BirthdayError("Nehum aniversário encontrado"));
      }
    } catch (e) {
      emit(BirthdayError(e.toString()));
    }
  }
}
