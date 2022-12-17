import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const List<String> list = <String>[
  '11Т',
  '11С',
  '10Т',
  '10С',
  '9А',
  '9М',
  '9В',
  '8А',
  '8Б',
  '8В',
  '8Г',
  '7К',
  '7Т',
  '7О',
  '7Я',
  '6К',
  '6О',
  '6Ф',
  '6Я',
  '5Я',
  '5Ф',
  '5О',
  '5Т',
  '2В',
  '4В',
  '2О',
  '3Э',
  '4Г',
  '4А',
  '3З',
  '4Б',
  '3Р',
  '4Э',
  '3Т',
  '1Р',
  '1Э',
  '2Т',
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
  var uri;
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
            debugPrint('1');
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
