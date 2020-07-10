# 🚨 flutter_siren

The Flutter port of the popular [Siren](https://github.com/ArtSabintsev/Siren), one way to notify users when a new version of your app is available and prompt them to upgrade.

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

## Customizing the prompt update. 

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

## Building your own prompt update.

Your can use the `updateIsAvailable` method to create your own way to alert the user about new updates. This method returns a boolean and you do your magic!  
```dart 
final siren = Siren();

FutureBuilder<bool>(
  future: updateIsAvailable(),
  builder: (context, AsyncSnapshot<bool> snapshot){ 
    if (snapshot.hasData) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[],
      );
    }
  }
);
```

## Inspiration
These awesome packages: [Siren](https://github.com/ArtSabintsev/Siren) and [react-native-siren](https://github.com/GantMan/react-native-siren)
