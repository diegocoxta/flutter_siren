import 'package:flutter/material.dart';
import 'package:flutter_siren/flutter_siren_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Siren Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Flutter Siren Demo'),
          ),
          body: Builder(
            builder: (context) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Press the following button to show the update dialog:',
                  ),
                  TextButton(
                    child: const Text('Check Update'),
                    onPressed: () => SirenUI.promptUser(context),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
