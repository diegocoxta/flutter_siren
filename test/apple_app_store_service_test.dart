import 'dart:convert';
import 'package:flutter_siren/services/apple_app_store.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  final appStore = AppleAppStore();

  void mockClient(Object response) {
    appStore.client = MockClient((request) async {
      return Response(json.encode(response), 200);
    });
  }

  test('should return the iOS Google Chrome app version', () async {
    mockClient({
      'resultCount': 1, 
      'results': [
        { 
          'version': '83.0.4103.88'
        }
      ]
    });

    final version = await appStore.getLatestVersion('com.google.chrome.ios');
    expect(version, '83.0.4103.88');
  });

  test('should not return the iOS Google Chrome app version', () async {
    mockClient({
      'resultCount': 0, 
      'results': []
    });

    final version = await appStore.getLatestVersion('com.google.chrome.iosx');
    expect(version, '');
  });
}
