import 'package:flutter_siren/entities/siren_store_response.dart';
import 'package:flutter_siren/entities/siren_store_service.dart';
import 'package:http/http.dart';

class SirenGooglePlayStore implements SirenStoreService<SirenStoreResponse> {
  static Client client = Client();

  @override
  Future<SirenStoreResponse> getStoreResponse({required String from}) async {
    final url = 'https://play.google.com/store/apps/details?id=$from&hl=en';
    final response = await client.get(Uri.parse(url));

    final match = RegExp(r'Current Version.+>([\d.]{1,20})(?=<\/span>)')
        .firstMatch(response.body);

    if (match == null) {
      return SirenStoreResponse(version: '', package: '', url: url);
    }

    var version = match[1]?.trim() ?? '';

    return SirenStoreResponse(version: version, package: from, url: url);
  }
}
