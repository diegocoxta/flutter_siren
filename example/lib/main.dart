import 'package:flutter/material.dart';
import 'package:flutter_siren/flutter_siren.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<void> _showPromptUpdate(BuildContext context) async {
    final siren = Siren();
    siren.promptUpdate(context);
  }

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
          title: Text('Flutter Siren Demo'),
        ),
        body: Builder(builder: (context) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Press the following button to show the update dialog:',
              ),
              FlatButton(
                child: Text('Check Update'),
                color: Colors.blue,
                textColor: Colors.white,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.blueAccent,
                onPressed: () => _showPromptUpdate(context),
              )
            ],
          ),
        ),
        )
      ),
    );
  }
}

