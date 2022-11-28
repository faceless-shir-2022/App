import 'package:flutter/material.dart';
import 'package:flutter_application_1/Authocompleater.dart';

class Navigator1 extends StatelessWidget {
  String _id;
  Navigator1({String id = ''}) : _id = id;
  String img = 'assets/image/fruktovaya/1.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$_id'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(left: 16.0, right: 116, top: 10),
                child: AutocompleteBasicExample(myText: 'начала')),
            Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.only(left: 16.0, right: 116, top: 54),
              child: const AutocompleteBasicExample(
                myText: 'конца',
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(right: 16, top: 64),
              alignment: Alignment.topRight,
              child: ElevatedButton(
                child: const Text("Начать"),
                onPressed: () {},
              ),
            ),
            // Container(
            //   child: Image.network("ссылка на пикчу не готова"),
            // ),
            Container(
              child: Image.asset(this.img),
              alignment: Alignment.center,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: ButtonBar(
                alignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                      onPressed: () {
                        this.img = 'assets/image/fruktovaya/1.jpg';
                      },
                      child: Text('1')),
                  TextButton(
                      onPressed: () {
                        this.img = 'assets/image/fruktovaya/2.jpg';
                      },
                      child: Text('2')),
                  TextButton(
                      onPressed: () {
                        this.img = 'assets/image/fruktovaya/3.jpg';
                      },
                      child: Text('3'))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
