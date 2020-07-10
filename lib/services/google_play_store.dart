import 'package:http/http.dart';
import 'package:flutter_siren/services/store_service.dart';

class GooglePlayStore implements StoreService {
  Client client = Client();
  
  @override
  Future<String> getLatestVersion(String package) async {
    final response = await client.get('https://play.google.com/store/apps/details?id=$package&hl=en');

    if (response == null) {
      return '';
    }

    final match = RegExp(r'Current Version.+>([\d.]{4,10})').firstMatch(response.body);

    if (match == null) {
      return '';
    }

    return match[1].trim();
  }
}