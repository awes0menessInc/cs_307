import 'package:flutter/material.dart';
import 'home.dart';
import 'splash.dart';
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
      ),
      // home: Home(),
      home: Splash(),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => Login(),
        '/register': (BuildContext context) => Register(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
