import 'package:http/http.dart';

import '../entities/store_details.dart';

class GooglePlayStore {
  static Client client = Client();

  static Future<StoreDetails> getStoreDetails({required String from}) async {
    final url =
        Uri.parse('https://play.google.com/store/apps/details?id=$from&hl=en');
    final response = await client.get(url);

    client.close();

    final match = RegExp(r'Current Version.+>([\d.]{1,20})(?=<\/span>)')
        .firstMatch(response.body);

    if (match == null) {
      return StoreDetails(version: '', package: "");
    }

    var version = match[1]?.trim() ?? '';

    return StoreDetails(version: version, package: from);
  }
}
