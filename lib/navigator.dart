import 'package:flutter/material.dart';
import 'package:flutter_application_1/Authocompleater.dart';

class Navigator1 extends StatelessWidget {
  final String _id;
  final String _img;
  String _isSearch;
  var A = TextEditingController();
  var B = TextEditingController();
  Navigator1(
      {String id = '',
      String img = 'assets/image/fruktovaya/1.jpg',
      String isSearch = 'nosearch'})
      : _id = id,
        _img = img,
        _isSearch = isSearch;

  // String img = 'assets/image/fruktovaya/1.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pushNamed(context, '/first');
          },
        ),
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
            Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(right: 120, left: 10, top: 30),
                  child: AutocompleteBasicExample(
                    myText: 'Введите точку начала пути',
                    controller_2: A,
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(
                    right: 120,
                    left: 10,
                  ),
                  child: AutocompleteBasicExample(
                    myText: 'Введите точку конца пути',
                    controller_2: B,
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: ButtonBar(
                      alignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/second/$_id/1/$_isSearch');
                            },
                            child: const Text('1')),
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/second/$_id/2/$_isSearch');
                            },
                            child: const Text('2')),
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/second/$_id/3/$_isSearch');
                            },
                            child: const Text('3'))
                      ]),
                ),
                // Container(
                //   child: Image.network("ссылка на пикчу не готова"),
                // ),
                Container(
                  alignment: Alignment.center,
                  // child: Image.network(
                  //     "http://tortik13.pythonanywhere.com/static/img/fruktovaya_floor$_img(1).jfif"),
                  child: Image.asset("assets/image/fruktovaya/$_img.jpg"),
                ),
                const Text('Вы ищите путь...')
              ],
            ),
            Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(right: 10, top: 40),
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.teal),
                    ),
                    child: const Text("Очистить"),
                    onPressed: () {
                      _isSearch = 'nosearch';
                      print('555');
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(right: 10, top: 10),
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                    child: const Text("  Начать  "),
                    onPressed: () {
                      _isSearch = 'search';
                      debugPrint(A.text);
                      debugPrint(B.text);
                      print('500');
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
