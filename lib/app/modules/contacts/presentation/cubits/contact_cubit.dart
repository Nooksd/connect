import 'package:connect/app/modules/contacts/domain/repos/contact_repo.dart';
import 'package:connect/app/modules/contacts/presentation/cubits/contact_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactCubit extends Cubit<ContactState> {
  final ContactRepo contactRepo;
  double scrollPosition = 0.0;
  int pageIndex = 1;

  ContactCubit({required this.contactRepo}) : super(ContactInitial());

  Future<void> getContacts(String name) async {
    emit(ContactLoading());

    try {
      final contacts = await contactRepo.getContacts(name);

      if (contacts.isNotEmpty) {
        emit(ContactsLoaded(contacts));
      } else {
        emit(ContactError("Nehum contato encontrado"));
      }
    } catch (e) {
      emit(ContactError(e.toString()));
    }
  }
}
