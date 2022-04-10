import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:quantity_input/quantity_input.dart';
import 'package:csv/csv.dart';
import 'dart:io';

const primaryColor = Color.fromARGB(255, 212, 22, 22);
List<List<dynamic>> _data = [];
List<int> quantity = [];
List<dynamic> totalNutrition = [];
void main() {
  runApp(MaterialApp(
      title: 'UMD Dining App',
      home: MainPage(),
      theme: ThemeData(
          appBarTheme: AppBarTheme(
        color: primaryColor,
      ))));
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  void _loadCSV() async {
    final _rawData = await rootBundle.loadString("assets/Dinersorted.csv");
    List<List<dynamic>> _listData =
        const CsvToListConverter().convert(_rawData);
    setState(() {
      _data = _listData;
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadCSV();
    while (_data == []) {
      sleep(const Duration(seconds: 5));
      print("loading....");
    }
    for (int i = 0; i < _data.length; i++) {
      quantity.add(0);
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'UMD Dining',
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
        body: Center(
            child: SizedBox(
          height: 300,
          width: 100,
          child: Column(children: [
            ElevatedButton(
              child: const Text('North Diner'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NorthDiner()),
                );
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: const Text('South Diner'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SouthDiner()),
                );
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: const Text('251 Diner'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Diner251()),
                );
              },
            ),
          ]),
        )));
  }
}

class NorthDiner extends StatefulWidget {
  const NorthDiner({Key? key}) : super(key: key);

  @override
  State<NorthDiner> createState() => _NorthDinerState();
}

class _NorthDinerState extends State<NorthDiner> {
  @override
  int simpleIntInput = 0;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('North Diner'),
      ),
      body: BodyLayout(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          for (int i = 0; i < _data.length; i++) {
            totalNutrition.add(0);
          }
          for (int i = 1; i < _data.length; i++) {
            if (quantity[i] != 0) {
              print("entered");
              for (int j = 0; j < _data[i].length; j++) {
                if (j == 2 || j == 3 || j == 4 || j == 5 || j == 8) {
                  totalNutrition[j] += (_data[i][j] * quantity[i]);
                }
              }
            }
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TotalCalorie()),
          );
        },
      ),
    );
  }
}

class TotalCalorie extends StatefulWidget {
  @override
  State<TotalCalorie> createState() => _TotalCalorieState();
}

class _TotalCalorieState extends State<TotalCalorie> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Total Calorie')),
        body: Center(
            child:
                const Text("Calorie: 472 Protein: 20 Carbs: 58 Vitamin C: 7")));
  }
}

class QuantityWidget extends StatefulWidget {
  int index = 0;
  QuantityWidget({int index = 0});
  @override
  State<StatefulWidget> createState() => QuantityWidgetState();
}

class QuantityWidgetState extends State<QuantityWidget> {
  @override
  var simpleIntInput = 0;
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      QuantityInput(
          minValue: 0,
          label: '',
          value: simpleIntInput,
          onChanged: (value) => setState(() {
                simpleIntInput = int.parse(value.replaceAll(',', ''));
                quantity[widget.index] = simpleIntInput;
                print(widget.index);
              })),
    ]));
  }
}

class SouthDiner extends StatefulWidget {
  const SouthDiner({Key? key}) : super(key: key);

  @override
  State<SouthDiner> createState() => _SouthDinerState();
}

class _SouthDinerState extends State<SouthDiner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('South Diner'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}

class Diner251 extends StatefulWidget {
  const Diner251({Key? key}) : super(key: key);

  @override
  State<Diner251> createState() => _Diner251State();
}

class _Diner251State extends State<Diner251> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('251 Diner'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}

class BodyLayout extends StatefulWidget {
  @override
  State<BodyLayout> createState() => _BodyLayoutState();
}

class _BodyLayoutState extends State<BodyLayout> {
  @override
  Widget build(BuildContext context) {
    return _myListView(context);
  }
}

Widget _myListView(BuildContext context) {
  // add another parameter as the dataset
  // backing data
  return ListView.builder(
    itemCount: _data.length,
    itemBuilder: (context, index) {
      return Row(children: <Widget>[
        Expanded(
          child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Text(
                _data[index][1].toString(),
              )),
        ),
        // Expanded(
        //   child: Padding(
        //       padding: const EdgeInsets.all(5.0),
        //       child: Text(
        //         _data[index][1].toString(),
        //       )),
        // ),
        // Expanded(
        //   child: Padding(
        //       padding: const EdgeInsets.all(5.0),
        //       child: Text(
        //         _data[index][3].toString(),
        //       )),
        // ),
        Expanded(
          child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Text(_data[index][4].toString())),
        ),
        Expanded(
          child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Text(_data[index][5].toString())),
        ),
        Expanded(
          child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Text(_data[index][6].toString())),
        ),
        // Expanded(
        //   child: Padding(
        //       padding: const EdgeInsets.all(5.0),
        //       child: Text(_data[index][6].toString())),
        // ),
        // Expanded(
        //   child: Padding(
        //       padding: const EdgeInsets.all(5.0),
        //       child: Text(_data[index][7].toString())),
        // ),
        Expanded(
          child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Text(_data[index][8].toString())),
        ),
        Expanded(
            flex: 4,
            child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: QuantityWidget(index: index))),
      ]);
    },
  );
}
