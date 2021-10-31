import 'package:flutter/material.dart';
import 'package:flutter_siren/flutter_siren.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final siren = Siren();

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
                    'Please change the iOS Bundle Identifier or the Android Package namespace for a value of an app published in stores and press the following button to show the update dialog:',
                  ),
                  TextButton(
                    child: const Text('Check Update'),
                    onPressed: () => siren.promptUpdate(context),
                  ),
                  FutureBuilder(
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                            'Local Version: ${snapshot.data.toString()}');
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text(snapshot.error?.toString() ?? "Error"));
                      } else {
                        return const Center(
                            child: Text('Local Version: Loading...'));
                      }
                    },
                    future: siren.localVersion,
                  ),
                  FutureBuilder(
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                            'Store Version: ${snapshot.data.toString()}');
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text(snapshot.error?.toString() ?? "Error"));
                      } else {
                        return const Center(
                            child: Text('Store Version: Loading...'));
                      }
                    },
                    future: siren.storeVersion,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
