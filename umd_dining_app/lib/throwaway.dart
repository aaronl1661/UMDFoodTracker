import 'package:flutter/material.dart';

void main() {
  runApp(DiningApp());
}

class DiningApp extends StatelessWidget {
  const DiningApp({Key? key}) : super(key: key);
  @override
  void redirectSouth() {}
  void redirect251() {}
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('UMD Dining App'),
        ),
        body: Column(children: <Widget>[
          ElevatedButton(
            child: Text('North Diner'),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const NorthDiner()));
            },
          ),
          ElevatedButton(
            child: Text('South Diner'),
            onPressed: redirectSouth,
          ),
          ElevatedButton(
            child: Text('251 Diner'),
            onPressed: redirect251,
          ),
        ]),
      ),
    );
  }

  void redirectNorth(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const NorthDiner()));
  }
}

class NorthDiner extends StatelessWidget {
  const NorthDiner({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: Text('New Screen')),
      body: Center(
        child: Text(
          'This is a new screen',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    ));
  }
}
