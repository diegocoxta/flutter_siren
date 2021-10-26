import 'dart:convert';

import 'package:http/http.dart';

import '../entities/store_details.dart';

class AppleAppStore {
  static Client client = Client();

  static Future<StoreDetails> getStoreDetails({required String from}) async {
    final url = Uri.parse('https://itunes.apple.com/lookup?bundleId=$from');
    final response = await client.get(url, headers: {
      'Cache-Control': 'no-cache',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    client.close();

    final decodedBody = json.decode(response.body);

    if (decodedBody == null || decodedBody['resultCount'] == 0) {
      return StoreDetails(version: '', package: '');
    }

    return StoreDetails(
        version: decodedBody['results'][0]['version'].toString(),
        package: decodedBody['results'][0]['trackId'].toString());
  }
}
