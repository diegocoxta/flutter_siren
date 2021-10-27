import 'package:flutter/material.dart';
import 'package:flutter_siren/flutter_siren.dart';
import 'package:url_launcher/url_launcher.dart';

class SirenUI {
  static Future<void> promptUser(BuildContext context,
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
        return FutureBuilder<SirenUpdate>(
            future: Siren.performCheck(),
            builder: (context, snapshot) {
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
                  final storeUrl = snapshot.data?.details.url ?? '';

                  if (storeUrl != '' && await canLaunch(storeUrl)) {
                    await launch(storeUrl, forceSafariVC: false);
                  }

                  if (!forceUpgrade) {
                    Navigator.of(context).pop();
                  }
                },
              ));

              if (snapshot.hasData) {
                return AlertDialog(
                    title: Text(title),
                    content: Text(message),
                    actions: buttons);
              }

              return Container();
            });
      },
    );
  }
}
