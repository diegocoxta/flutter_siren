import 'package:http/testing.dart';
import 'package:http/http.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_siren/services/google_play_store.dart';

void main() async {

  void mockClient(String response) {
    GooglePlayStore.client = MockClient((request) async {
      return Response(response, 200);
    });
  }

  test('should return the Android SanarFlix app version', () async {
     mockClient('''
    <div class="hAyfc"><div class="BgcNfc">Size</div><span class="htlgb"><div class="IQ1z0d"><span class="htlgb">42M</span></div></span></div><div class="hAyfc"><div class="BgcNfc">Installs</div><span class="htlgb"><div class="IQ1z0d"><span class="htlgb">100,000+</span></div></span></div><div class="hAyfc"><div class="BgcNfc">Current Version</div><span class="htlgb"><div class="IQ1z0d"><span class="htlgb">1.25.0</span></div></span></div><div class="hAyfc"><div class="BgcNfc">Requires Android</div><span class="htlgb"><div class="IQ1z0d"><span class="htlgb">4.4 and up</span></div></span></div><div class="hAyfc"><div class="BgcNfc">Content Rating</div><span class="htlgb"><div class="IQ1z0d"><span class="htlgb"><div>All ages</div>
    ''');

    final version = await GooglePlayStore.getLatestVersion(from: 'com.android.chrome');
    expect(version, '1.25.0');
  });

  test('should not return the Android Google Chrome app version', () async {
    mockClient('<html><body>not expected response</body></html>');

    final version = await GooglePlayStore.getLatestVersion(from: 'com.android.chrome');
    expect(version, null);
  });
}
