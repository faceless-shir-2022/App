import 'package:flutter/material.dart';
import 'package:flutter_application_1/DropDownClass.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Настройки')),
      body: Center(
        child: Stack(
          children: <Widget>[
            Container(
              child: DropdownButtonExample(),
              alignment: Alignment.topCenter,
            )
          ],
        ),
      ),
    );
  }
}
