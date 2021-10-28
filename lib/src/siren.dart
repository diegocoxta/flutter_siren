import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_siren/entities/siren_store_response.dart';
import 'package:flutter_siren/entities/siren_store_service.dart';
import 'package:flutter_siren/services/siren_apple_app_store.dart';
import 'package:flutter_siren/services/siren_google_play_store.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';

class Siren {
  SirenStoreResponse response =
      SirenStoreResponse(version: '', package: '', url: '');

  static SirenStoreService _getStoreClient() {
    if (Platform.isIOS) {
      return SirenAppleAppStore();
    }

    return SirenGooglePlayStore();
  }

  Future<bool> updateIsAvailable() async {
    final packageInfo = await PackageInfo.fromPlatform();

    final currentVersion = packageInfo.version;
    final packageName = packageInfo.packageName;

    response = await _getStoreClient().getStoreResponse(from: packageName);

    final updateIsAvailable =
        Version.parse(response.version) > Version.parse(currentVersion);

    return updateIsAvailable;
  }

  Future<void> promptUpdate(BuildContext context,
      {String title = 'Update Available',
      String message = '''
There is an updated version available on the App Store. Would you like to upgrade?''',
      String buttonUpgradeText = 'Upgrade',
      String buttonCancelText = 'Cancel',
      bool forceUpgrade = false}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return FutureBuilder<bool>(
            future: updateIsAvailable(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
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
                  onPressed: () async {
                    final url = response.url;

                    if (url != '' && await canLaunch(url)) {
                      await launch(url, forceSafariVC: false);
                    }

                    if (!forceUpgrade) {
                      Navigator.of(context).pop();
                    }
                  },
                ));

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
