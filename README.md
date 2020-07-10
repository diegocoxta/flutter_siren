# 📦 flutter_siren

The Flutter port of the popular [Siren](https://github.com/ArtSabintsev/Siren), a package to notify users when a new version of your app is available and prompt them to upgrade.

🚀 Supports iOS and Android.

## Install
Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  flutter_siren: <latest-version>
```

And install the packages from the command line:

```sh
$ flutter pub get
```

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:flutter_siren/flutter_siren.dart';

// Check update on button press with AlertDialog.

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Text('Check Update'),
                    onPressed: () {
                      final siren = Siren();
                      siren.promptUpdate(context);
                    },
                  )
                ],
              ),
            );
          }
        )
      ),
    );
  }
}

```

## Customizing the Prompt Update. 

| value             | Description             | default |
| -------------     |-------------            | -----|
|title              | Alert title             | Update Available |
|message            | Alert Message           | There is an updated version available on the App Store. Would you like to upgrade? |
|buttonUpgradeText  | Upgrade Button Text     | Upgrade |
|buttonCancelText   | Cancel Button Text      | Cancel |
|forceUpgrade       | Hide Cancel Button      | false |

```dart
// Passing custom options.
siren.promptUpdate(context, 
  title: "My alert title", 
  message: "Bro, update my app", 
  buttonUpgradeText: "Download",  
  buttonCancelText: "Nop",
  forceUpgrade: true
);
```

