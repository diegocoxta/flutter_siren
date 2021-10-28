import 'dart:convert';

import 'package:flutter_siren/src/entities/siren_store_response.dart';
import 'package:flutter_siren/src/entities/siren_store_service.dart';
import 'package:http/http.dart';

class SirenAppleAppStore implements SirenStoreService<SirenStoreResponse> {
  static Client client = Client();

  @override
  Future<SirenStoreResponse> getStoreResponse({required String from}) async {
    final url = Uri.parse('https://itunes.apple.com/lookup?bundleId=$from');
    final response = await client.get(url, headers: {
      'Cache-Control': 'no-cache',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    final decodedBody = json.decode(response.body);

    if (decodedBody == null || decodedBody['resultCount'] == 0) {
      return SirenStoreResponse(version: '', package: '', url: '');
    }

    final version = decodedBody['results'][0]['version'].toString();
    final trackerId = decodedBody['results'][0]['trackId'].toString();

    return SirenStoreResponse(
        version: version,
        package: trackerId,
        url: 'https://apps.apple.com/app/id$trackerId?mt=8');
  }
}
