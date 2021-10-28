import 'dart:convert';

import 'package:flutter_siren/src/services/siren_apple_app_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() async {
  void mockClient(Object response) {
    SirenAppleAppStore.client = MockClient((request) async {
      return Response(json.encode(response), 200);
    });
  }

  test('should return the iOS Google Chrome app version', () async {
    mockClient({
      'resultCount': 1,
      'results': [
        {'version': '83.0.4103.88', 'trackId': 535886823}
      ]
    });

    final details = await SirenAppleAppStore()
        .getStoreResponse(from: 'com.google.chrome.ios');

    expect(details.version, '83.0.4103.88');
    expect(details.package, '535886823');
  });

  test('should not return the iOS Google Chrome app version', () async {
    mockClient({'resultCount': 0, 'results': []});

    final details = await SirenAppleAppStore()
        .getStoreResponse(from: 'com.google.chrome.iosx');

    expect(details.version, '');
    expect(details.package, '');
  });
}
