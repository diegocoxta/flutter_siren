library flutter_siren;

import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';

import 'services/apple_app_store.dart';
import 'services/google_play_store.dart';

class Siren {
  String storeUrl;

  Future<String> _getVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<String> _getPackage() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }

  void _openStoreUrl(BuildContext context) async {
    if (storeUrl == null) {
      return null;
    }

    try {
      if (await canLaunch(storeUrl)) {
        await launch(storeUrl, forceSafariVC: false);
      }
    } on PlatformException {}
  }

  Future<bool> updateIsAvailable() async {
    final currentVersion = await _getVersion();
    final packageName = await _getPackage();
    var newVersion = currentVersion;

    if (Platform.isIOS) {
      final applicationDetails =
          await AppleAppStore.getStoreDetails(from: packageName);
      storeUrl =
          'https://apps.apple.com/app/id${applicationDetails.trackId.toString()}?mt=8';
      newVersion = applicationDetails.version;
    }

    if (Platform.isAndroid) {
      storeUrl = 'https://play.google.com/store/apps/details?id=$packageName';
      newVersion = await GooglePlayStore.getLatestVersion(from: packageName);
    }

    return Version.parse(newVersion) > Version.parse(currentVersion);
  }

  Future<void> promptUpdate(BuildContext context,
      {String title = 'Update Available',
      String message = '''
There is an updated version available on the App Store. Would you like to upgrade?''',
      String buttonUpgradeText = 'Upgrade',
      String buttonCancelText = 'Cancel',
      bool forceUpgrade = false}) async {
    final buttons = <Widget>[];

    if (!forceUpgrade) {
      buttons.add(TextButton(
        child: Text(buttonCancelText),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ));
    }

    buttons.add(TextButton(
      child: Text(buttonUpgradeText),
      onPressed: () {
        _openStoreUrl(context);
        Navigator.of(context).pop();
      },
    ));

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return FutureBuilder<bool>(
            future: updateIsAvailable(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return AlertDialog(
                  title: Text(title),
                  content: Text(message),
                  actions: buttons,
                );
              }

              return Container();
            });
      },
    );
  }
}
