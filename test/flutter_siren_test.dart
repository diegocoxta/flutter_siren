import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_siren/flutter_siren.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('should display update status', () async {
    final siren = Siren();
    final hasUpdate = await siren.updateIsAvailable();
    expect(hasUpdate, true);
  });
}
