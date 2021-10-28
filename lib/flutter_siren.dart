library flutter_siren;

import 'dart:io' show Platform;

import 'package:flutter_siren/entities/siren_store_response.dart';
import 'package:flutter_siren/entities/siren_store_service.dart';
import 'package:flutter_siren/services/apple_app_store.dart';
import 'package:flutter_siren/services/google_play_store.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

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

    final updateIsAvailable = Version.parse(storeDetails.version) > Version.parse(currentVersion);

    return SirenUpdate(
        updateIsAvailable: updateIsAvailable, details: storeDetails);
  }
}

class SirenUpdate {
  final SirenStoreResponse details;
  final bool updateIsAvailable;

  SirenUpdate({required this.details, required this.updateIsAvailable});
}
