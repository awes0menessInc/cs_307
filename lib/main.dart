import 'package:flutter/material.dart';
import 'register.dart';
import 'login.dart';
import 'splash.dart';
import 'home.dart';
import 'register.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        '/register': (BuildContext context) => Register(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}