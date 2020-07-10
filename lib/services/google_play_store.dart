import 'package:http/http.dart';

class GooglePlayStore {
  static Client client = Client();

  static Future<String> getLatestVersion({String from}) async {
    final response = await client
        .get('https://play.google.com/store/apps/details?id=$from&hl=en');

    if (response == null) {
      return null;
    }

    final match =
        RegExp(r'Current Version.+>([\d.]{4,10})').firstMatch(response.body);

    if (match == null) {
      return null;
    }

    return match[1].trim();
  }
}
