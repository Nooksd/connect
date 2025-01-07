import 'package:connect/app/core/services/http/my_http_client.dart';
import 'package:connect/app/modules/contacts/domain/entities/contact.dart';
import 'package:connect/app/modules/contacts/domain/repos/contact_repo.dart';

class MongoContactRepo implements ContactRepo {
  MyHttpClient http;

  MongoContactRepo({required this.http});

  @override
  Future<List<Contact>> getContacts(String name) async {
    try {
      final response = await http.get('/users?name=$name');

      if (response["status"] == 200) {
        final data = response["data"]["users"];

        if (data is List) {
          final List<Contact> allContacts = data
              .map((post) => Contact.fromJson(post as Map<String, dynamic>))
              .toList();
          return allContacts;
        } else {
          throw Exception("O formato esperado da resposta é uma lista.");
        }
      }

      return Future.value([]);
    } catch (e) {
      throw Exception(e);
    }
  }
}
