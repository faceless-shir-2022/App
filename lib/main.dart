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
        '/settings': (context) => const Settings()
      },
      onGenerateRoute: (routeSettings) {
        var path = routeSettings.name.toString().split('/');
        if (path[1] == 'second') {
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
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Color.fromARGB(255, 180, 224, 251)),
      // home: Navigator();
    );
  }
}
