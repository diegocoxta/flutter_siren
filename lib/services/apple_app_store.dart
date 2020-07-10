
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter_siren/services/store_service.dart';

class AppleAppStore implements StoreService {
  Client client = new Client();

  @override
  Future<String> getLatestVersion(String package) async {
    final response = await client.get(
      'https://itunes.apple.com/lookup?bundleId=$package', 
      headers: {
        'Cache-Control': 'no-cache',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      }
    );

    if (response == null) {
      return '';
    }

    final decodedBody = json.decode(response.body);

    if (decodedBody == null || decodedBody['resultCount'] == 0) {
      return '';
    }

    return decodedBody['results'][0]['version'];
  }
}