import 'package:flutter/material.dart';
import 'home.dart';

import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'twistter',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      // home: Home(),
      home: SplashPage(),
      routes: <String, WidgetBuilder> {
        '/login': (BuildContext context) => LoginPage(),
        '/register': (BuildContext context) => RegisterPage(),
      }
      debugShowCheckedModeBanner: false,
    );
  }
}