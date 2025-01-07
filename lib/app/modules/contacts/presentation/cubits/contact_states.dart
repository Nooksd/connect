import 'package:connect/app/modules/contacts/domain/entities/contact.dart';

abstract class ContactState {
  get contacts => null;
}

class ContactInitial extends ContactState {}

class ContactLoading extends ContactState {}

class ContactsLoaded extends ContactState {
  @override
  final List<Contact> contacts;

  ContactsLoaded(this.contacts);
}

class ContactError extends ContactState {
  final String message;

  ContactError(this.message);
}
