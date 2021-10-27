import 'package:flutter_siren/services/google_play_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() async {
  void mockClient(String response) {
    GooglePlayStore.client = MockClient((request) async {
      return Response(response, 200);
    });
  }

  test('should return the correctly Android app version', () async {
    mockClient('''
    <div class="hAyfc"><div class="BgcNfc">Size</div><span class="htlgb"><div class="IQ1z0d"><span class="htlgb">42M</span></div></span></div><div class="hAyfc"><div class="BgcNfc">Installs</div><span class="htlgb"><div class="IQ1z0d"><span class="htlgb">100,000+</span></div></span></div><div class="hAyfc"><div class="BgcNfc">Current Version</div><span class="htlgb"><div class="IQ1z0d"><span class="htlgb">2.3.5</span></div></span></div><div class="hAyfc"><div class="BgcNfc">Requires Android</div><span class="htlgb"><div class="IQ1z0d"><span class="htlgb">4.4 and up</span></div></span></div><div class="hAyfc"><div class="BgcNfc">Content Rating</div><span class="htlgb"><div class="IQ1z0d"><span class="htlgb"><div>All ages</div>
    ''');

    final details =
        await GooglePlayStore().getStoreUpdate(from: 'com.android.chrome');

    expect(details.version, '2.3.5');
    expect(details.package, 'com.android.chrome');
  });

  test('should not return the Android Google Chrome app version', () async {
    mockClient('<html><body>not expected response</body></html>');

    final details =
        await GooglePlayStore().getStoreUpdate(from: 'com.android.chrome');

    expect(details.version, '');
    expect(details.package, '');
  });
}
