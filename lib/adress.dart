import 'dart:ffi';

import 'package:flutter/material.dart';

class Adress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Выберите адрес вашей школы'),
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              padding:
                  EdgeInsets.only(top: 15, bottom: 300, left: 120, right: 120),
              child: Image.asset(
                "assets/image/1school.jpg",
                fit: BoxFit.scaleDown,
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top: 200),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/second/Фруктовая/1');
                },
                child: Text('Фруктовая'),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding:
                  EdgeInsets.only(top: 130, bottom: 190, left: 120, right: 120),
              child: Image.asset(
                "assets/image/2school.jpg",
                // fit: BoxFit.scaleDown,
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 175),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/second/Чонгарская/1');
                },
                child: Text('Чонгарская'),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(bottom: 100, left: 120, right: 120),
              child: Image.asset(
                "assets/image/3school.jpg",
                // fit: BoxFit.scaleDown,
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(bottom: 45),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/second/Криворожская/1');
                },
                child: Text('Криворожская'),
              ),
            ),
          ],
        ),
        //
      ),
    );
  }
}
