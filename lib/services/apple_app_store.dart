import 'dart:convert';
import 'package:http/http.dart';

class StoreDetails {
  final String version;
  final int trackId;

  StoreDetails({this.version, this.trackId});
}

class AppleAppStore {
  static Client client = Client();

  static Future<StoreDetails> getStoreDetails({String from}) async {
    final response = await client
        .get('https://itunes.apple.com/lookup?bundleId=$from', headers: {
      'Cache-Control': 'no-cache',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    if (response == null) {
      return StoreDetails();
    }

    final decodedBody = json.decode(response.body);

    if (decodedBody == null || decodedBody['resultCount'] == 0) {
      return StoreDetails();
    }

    return StoreDetails(
        version: decodedBody['results'][0]['version'],
        trackId: decodedBody['results'][0]['trackId']);
  }
}
