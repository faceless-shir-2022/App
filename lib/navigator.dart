import 'package:flutter/material.dart';
import 'package:flutter_application_1/Authocompleater.dart';
import 'package:flutter_application_1/alertDialog.dart';
import 'package:http/http.dart' as http;
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';

class Navigator1 extends StatelessWidget {
  final String _id;
  final String _img;
  String _isSearch;
  var A = TextEditingController();
  var B = TextEditingController();
  String _startA;
  String _finishB;
  Navigator1(
      {String id = '',
      String img = 'assets/image/fruktovaya/1.jpg',
      String isSearch = 'nosearch',
      startA = 'Введите точку начала пути',
      finishB = 'Введите точку конца пути'})
      : _id = id,
        _img = img,
        _isSearch = isSearch,
        _startA = startA,
        _finishB = finishB;

  // String img = 'assets/image/fruktovaya/1.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            imageCache.clear();
            imageCache.clearLiveImages();
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
                    myText: _startA,
                    controller_2: A,
                    schoolAdress: _id,
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(
                    right: 120,
                    left: 10,
                  ),
                  child: AutocompleteBasicExample(
                    myText: _finishB,
                    controller_2: B,
                    schoolAdress: _id,
                  ),
                ),
                Container(
                  child: Text('Выберите этаж:', textAlign: TextAlign.center),
                  padding: EdgeInsets.only(top: 25),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: ButtonBarSuper(
                    wrapType: WrapType.balanced,
                    wrapFit: WrapFit.divided,
                    spacing: 1,
                    buttonHeight: 30,
                    buttonMinWidth: 10,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context,
                              '/second/$_id/1/$_isSearch/$_startA/$_finishB');
                        },
                        child: const Text('1'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context,
                              '/second/$_id/2/$_isSearch/$_startA/$_finishB');
                        },
                        child: const Text('2'),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context,
                                '/second/$_id/3/$_isSearch/$_startA/$_finishB');
                          },
                          child: const Text('3')),
                      if (_id == 'Чонгарская') ...[
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context,
                                  '/second/$_id/4/$_isSearch/$_startA/$_finishB');
                            },
                            child: const Text('4')),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context,
                                  '/second/$_id/5/$_isSearch/$_startA/$_finishB');
                            },
                            child: const Text('5')),
                      ]
                    ],
                  ),
                ),
                // Container(
                //   alignment: Alignment.bottomCenter,
                //   child: ButtonBar(
                //     alignment: MainAxisAlignment.spaceAround,
                //     children: <Widget>[
                //       if (_id == 'Чонгарская') ...[
                //         ElevatedButton(
                //             onPressed: () {
                //               Navigator.pushNamed(context,
                //                   '/second/$_id/4/$_isSearch/$_startA/$_finishB');
                //             },
                //             child: const Text('4')),
                //         ElevatedButton(
                //             onPressed: () {
                //               Navigator.pushNamed(context,
                //                   '/second/$_id/5/$_isSearch/$_startA/$_finishB');
                //             },
                //             child: const Text('5')),
                //       ],
                //     ],
                //   ),
                // ),
                // Container(
                //   child: Image.network("ссылка на пикчу не готова"),
                // ),
                if (_isSearch == 'nosearch' && _id == 'Фруктовая') ...[
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset("assets/image/fruktovaya/$_img.jpg"),
                  ),
                ] else if (_isSearch == 'search' && _id == 'Фруктовая') ...[
                  Container(
                    alignment: Alignment.center,
                    child: Image.network(
                        "http://tortik13.pythonanywhere.com/static/img/fruktovaya_floor$_img(1).jfif"),
                  ),
                ] else if (_isSearch == 'nosearch' && _id == 'Чонгарская') ...[
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset("assets/image/chongarskaya/$_img.jpg"),
                  ),
                ] else if (_isSearch == 'search' && _id == 'Чонгарская') ...[
                  Container(
                    alignment: Alignment.center,
                    child: Image.network(
                        "http://tortik13.pythonanywhere.com/static/img/chongarskaya_floor$_img(1).jfif"),
                  ),
                ] else if (_isSearch == 'nosearch' &&
                    _id == 'Криворожская') ...[
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset("assets/image/krivorozhskaya/$_img.jpg"),
                  ),
                ] else if (_isSearch == 'search' && _id == 'Криворожская') ...[
                  Container(
                    alignment: Alignment.center,
                    child: Image.network(
                        "http://tortik13.pythonanywhere.com/static/img/krivorozhskaya_floor$_img(1).jfif"),
                  ),
                ],
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
                    child: const Text("Очистить"),
                    onPressed: () {
                      _isSearch = 'nosearch';
                      _startA = 'Введите точку начала пути';
                      _finishB = 'Введите точку конца пути';
                      Navigator.pushNamed(context,
                          '/second/$_id/1/$_isSearch/$_startA/$_finishB');
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
                      imageCache.clear();
                      imageCache.clearLiveImages();
                      // debugPrint(A.text);
                      // debugPrint(B.text);
                      _startA = A.text;
                      _finishB = B.text;

                      if (_startA == '' || _finishB == '') {
                        _isSearch = 'nosearch';
                        _startA = '';
                        _finishB = '';
                        showDialog(
                            context: context,
                            builder: (_) => DialogWrongData());
                      } else if (_startA == '100' || _finishB == 'Раздевалка') {
                        showDialog(
                            context: context,
                            builder: (_) => Checkroom(
                                  adress: _id,
                                ));
                      } else if (_id == 'Фруктовая') {
                        http.get(Uri.parse(
                            'http://tortik13.pythonanywhere.com/fruktovaya/$_startA/$_finishB'));
                        Navigator.pushNamed(context,
                            '/second/$_id/$_img/$_isSearch/$_startA/$_finishB');
                      } else if (_id == 'Чонгарская') {
                        http.get(Uri.parse(
                            'http://tortik13.pythonanywhere.com/chongarskaya/$_startA/$_finishB'));
                        Navigator.pushNamed(context,
                            '/second/$_id/$_img/$_isSearch/$_startA/$_finishB');
                      } else if (_id == 'Криворожская') {
                        http.get(Uri.parse(
                            'http://tortik13.pythonanywhere.com/krivorozhskaya/$_startA/$_finishB'));
                        Navigator.pushNamed(context,
                            '/second/$_id/$_img/$_isSearch/$_startA/$_finishB');
                      }

                      imageCache.clear();
                      imageCache.clearLiveImages();
                      // 'http://tortik13.pythonanywhere.com/fruktovaya/$_startA/$_finishB'));
                      print('ok');
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
