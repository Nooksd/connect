import 'package:connect/app/modules/contacts/domain/entities/contact.dart';

abstract class ContactRepo {
  Future<List<Contact>> getContacts(String name);
}
