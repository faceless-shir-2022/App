import 'package:flutter/material.dart';
import 'package:flutter_application_1/DropDownClass.dart';
import 'package:flutter_application_1/alertDialog.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 10),
              child: const Text('Выберите класс:'),
            ),
            Container(
              alignment: Alignment.topCenter,
              child: const DropdownButtonExample(),
            ),
            Container(
              child: const DialogExample(),
            )
          ],
        ),
      ),
    );
  }
}
