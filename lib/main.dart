import 'package:flutter/material.dart';   

import 'package:twistter/register.dart';
import 'package:twistter/login.dart';
import 'package:twistter/splash.dart';
import 'package:twistter/search.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'twistter',
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Color(0xff55b0bd)
      ),
      home: Splash(),
      routes: <String, WidgetBuilder> {
        '/login': (BuildContext context) => Login(),
        '/register': (BuildContext context) => Register(),
        '/search': (BuildContext context) => Search(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}