import 'package:flutter/material.dart';
import 'package:flutter_application_1/navigator.dart';
import 'package:flutter_application_1/adress.dart';
import 'package:flutter_application_1/settings.dart';

void main() => runApp(MainWin());

class MainWin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: '/first',
        routes: {
          '/second': (context) => Navigator1(),
          '/first': (context) => Adress(),
          '/settings': (context) => Settings()
        },
        onGenerateRoute: (routeSettings) {
          var path = routeSettings.name.toString().split('/');
          if (path[1] == 'second' && (path[5] != '' || path[6] != '')) {
            return MaterialPageRoute(
                builder: (context) => Navigator1(
                      id: path[2],
                      img: path[3],
                      isSearch: path[4],
                      startA: path[5],
                      finishB: path[6],
                    ),
                settings: routeSettings);
          } else if (path[1] == 'second') {
            return MaterialPageRoute(
                builder: (context) => Navigator1(
                      id: path[2],
                      img: path[3],
                      isSearch: path[4],
                    ),
                settings: routeSettings);
          }
        },
        theme: ThemeData(
            primarySwatch: Colors.green,
            scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255)
            // home: Navigator();
            ));
  }
}
