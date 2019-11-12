import 'package:flutter/material.dart';
import 'register.dart';
import 'login.dart';
import 'splash.dart';
import 'search.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'twistter',
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Color(0xff55b0bd)
      ),
      // home: Home(),
      home: Splash(),
      routes: <String, WidgetBuilder> {
        '/login': (BuildContext context) => Login(),
<<<<<<< HEAD
        // '/register': (BuildContext context) => Register(),
=======
        '/register': (BuildContext context) => Register(),
        '/search': (BuildContext context) => Search(),
>>>>>>> 97c5fb6f2ef30539da6f6ef472ebb0b955e9088c
      },
      debugShowCheckedModeBanner: false,
    );
  }
}