import 'package:flutter/material.dart';
import 'package:flutter_application_1/navigator.dart';
import 'package:flutter_application_1/adress.dart';
import 'package:flutter_application_1/settings.dart';

void main() => runApp(CCTracker());

class CCTracker extends StatelessWidget {
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
        if (path[1] == 'second') {
          return MaterialPageRoute(
              builder: (context) => Navigator1(id: path[2]),
              settings: routeSettings);
        }
      },
      // title: 'Awesome CC Tracker',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Color.fromARGB(255, 180, 224, 251)),
      // home: Navigator();
    );
  }
}
