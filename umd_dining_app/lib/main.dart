import 'package:flutter/material.dart';
import 'package:quantity_input/quantity_input.dart';

const primaryColor = Color.fromARGB(255, 212, 22, 22);
List<Food> list1 = [
  Food(1, "banana", "Macrussy"),
  Food(2, "test1", "Macrussy"),
  Food(3, "test2", "Macrussy"),
  Food(4, "test3", "Macrussy"),
  Food(5, "test4", "Macrussy"),
  Food(5, "test4", "Macrussy"),
  Food(5, "test4", "Macrussy"),
  Food(5, "test4", "Macrussy"),
  Food(5, "test4", "Macrussy"),
  Food(5, "test4", "Macrussy"),
  Food(5, "test4", "Macrussy"),
  Food(5, "test4", "Macrussy"),
  Food(5, "test4", "Macrussy"),
  Food(5, "test4", "Macrussy"),
  Food(5, "test4", "Macrussy"),
  Food(5, "test4", "Macrussy"),
  Food(5, "test4", "Macrussy"),
  Food(5, "test4", "Macrussy"),
  Food(5, "test4", "Macrussy"),
  Food(5, "test4", "Macrussy"),
  Food(5, "test4", "Macrussy"),
  Food(5, "test4", "Macrussy"),
  Food(5, "test4", "Macrussy"),
  Food(5, "test4", "Macrussy"),
  Food(5, "test4", "Macrussy"),
];
int index = 0;
void main() {
  runApp(MaterialApp(
      title: 'UMD Dining App',
      home: MainPage(),
      theme: ThemeData(
          appBarTheme: AppBarTheme(
        color: primaryColor,
      ))));
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'UMD Dining',
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
        body: Center(
            child: SizedBox(
          height: 120,
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
    );
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

class Food {
  int calorie = 0;
  int quantity = 0;
  String name = "";
  String text = "";
  Food(int calorie, String name, String text) {
    this.calorie = calorie;
    this.quantity = quantity;
    this.name = name;
    this.text = text;
  }
}

Widget _myListView(BuildContext context) {
  // add another parameter as the dataset
  // backing data

  return ListView.builder(
    itemCount: list1.length,
    itemBuilder: (context, index) {
      return Row(children: <Widget>[
        Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              list1[index].name,
            )),
        Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              list1[index].calorie.toString(),
            )),
        Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              list1[index].text,
            )),
        Padding(padding: const EdgeInsets.all(5.0), child: QuantityWidget())
      ]);
    },
  );
}

class QuantityWidget extends StatefulWidget {
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
          value: simpleIntInput,
          onChanged: (value) => setState(() {
                simpleIntInput = int.parse(value.replaceAll(',', ''));
                list1[index].quantity++;
              })),
    ]));
  }
}
