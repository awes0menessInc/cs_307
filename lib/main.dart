import 'package:flutter/material.dart';
import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'twistter',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}