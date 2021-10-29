import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';

import './entities/siren_store_response.dart';
import './entities/siren_store_service.dart';
import './services/siren_apple_app_store.dart';
import './services/siren_google_play_store.dart';

/// This class allows you to check the application store for new versions of your app.
class Siren {
  SirenStoreResponse _response =
      SirenStoreResponse(version: '', package: '', url: '');

  static SirenStoreService _getStoreClient() {
    if (Platform.isAndroid) {
      return SirenGooglePlayStore();
    }

    if (Platform.isIOS || Platform.isMacOS) {
      return SirenAppleAppStore();
    }

    throw UnimplementedError('This lib only supports Android, iOS and MacOS');
  }

  /// This method checks for an update in the application store and returns if there is a newer version than the local one.
  Future<bool> updateIsAvailable() async {
    final packageInfo = await PackageInfo.fromPlatform();

    final currentVersion = packageInfo.version;
    final packageName = packageInfo.packageName;

    _response = await _getStoreClient().getStoreResponse(from: packageName);

    final updateIsAvailable =
        Version.parse(_response.version) > Version.parse(currentVersion);

    return updateIsAvailable;
  }

  /// This method shows an customizable AlertDialog if an update is available.
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
                    final url = _response.url;

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
