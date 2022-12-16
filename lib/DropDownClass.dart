import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const List<String> list = <String>[
  '11T',
  '11C',
  '10T',
  '10C',
  '9М',
  '9A',
  '9B',
  '8A',
  '8Б',
  '8B',
  '8Г',
  '7K',
  '7O',
  '7T',
  '7Я',
  '6K',
  '6O',
  '6Ф',
  '6Я',
  '5Я',
  '5Ф',
  '5O',
  '5T',
  '4A',
  '4Б',
  '4В',
  '4Г',
  '3З',
  '3Э',
  '3Р',
  '3Т',
  '2В',
  '2Т',
  '1Р',
  '1Э'
];
// var config = File("/assets/classes.txt");
// List<String> list = config.readAsLinesSync(encoding: utf8);

class DropdownButtonExample extends StatefulWidget {
  final A;
  final B;
  final adress;
  const DropdownButtonExample({super.key, this.A, this.B, this.adress});

  @override
  State<DropdownButtonExample> createState() =>
      _DropdownButtonExampleState(A: A, B: B, adress: adress);
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  _DropdownButtonExampleState({this.A, this.B, this.adress});
  String dropdownValue = list.first;
  final A;
  final B;
  final adress;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
          if (A == 'Раздевалка') {
            http.get(Uri.parse(
                'http://tortik13.pythonanywhere.com/fruktovaya/$dropdownValue/$B'));
            Navigator.pushNamed(
                context, '/second/$adress/1/search/$dropdownValue/$B');
            imageCache.clear();
            imageCache.clearLiveImages();
          } else {
            http.get(Uri.parse(
                'http://tortik13.pythonanywhere.com/fruktovaya/$A/$dropdownValue'));
            Navigator.pushNamed(
                context, '/second/$adress/1/search/$A/$dropdownValue');
            imageCache.clear();
            imageCache.clearLiveImages();
          }
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
