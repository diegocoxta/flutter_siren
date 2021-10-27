library flutter_siren;

import 'dart:io' show Platform;

import 'package:flutter_siren/entities/siren_store_response.dart';
import 'package:flutter_siren/entities/siren_store_service.dart';
import 'package:flutter_siren/services/apple_app_store.dart';
import 'package:flutter_siren/services/google_play_store.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Siren {
  static SirenStoreService _getStoreClient() {
    if (Platform.isIOS) {
      return AppleAppStore();
    }

    return GooglePlayStore();
  }

  static Future<SirenUpdate> performCheck() async {
    final packageInfo = await PackageInfo.fromPlatform();

    final currentVersion = packageInfo.version;
    final packageName = packageInfo.packageName;

    final storeDetails =
        await _getStoreClient().getStoreUpdate(from: packageName);

    // TODO: Implement a new way to check and parse the version of app.
    var newVersion = currentVersion;
    newVersion = storeDetails.version;

    final updateIsAvailable = currentVersion != newVersion;

    return SirenUpdate(
        updateIsAvailable: updateIsAvailable, details: storeDetails);
  }
}

class SirenUpdate {
  final SirenStoreResponse details;
  final bool updateIsAvailable;

  SirenUpdate({required this.details, required this.updateIsAvailable});
}
