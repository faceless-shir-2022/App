import 'package:flutter/material.dart';

class Adress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выберите адрес вашей школы'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              width: 250,
              padding: EdgeInsets.only(top: 15),
              child: Image.asset(
                "assets/image/1school.jpg",
                fit: BoxFit.scaleDown,
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/second/Фруктовая/1/nosearch');
                },
                child: Text('Фруктовая'),
              ),
            ),
            Container(
              width: 250,
              alignment: Alignment.center,
              child: Image.asset(
                "assets/image/2school.jpg",
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/second/Чонгарская/1/nosearch');
                },
                child: Text('Чонгарская'),
              ),
            ),
            Container(
              width: 250,
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/image/3school.jpg",
                // fit: BoxFit.scaleDown,
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                      context, '/second/Криворожская/1/nosearch');
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
