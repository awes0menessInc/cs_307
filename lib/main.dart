import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:twistter/register.dart';
import 'package:twistter/login.dart';
import 'package:twistter/splash.dart';
import 'package:twistter/search.dart';
import 'package:twistter/auth_service.dart';
import 'package:twistter/followers.dart';
import 'package:twistter/following.dart';

void main() => runApp(
      ChangeNotifierProvider<AuthService>(
        child: MyApp(),
        builder: (BuildContext context) {
          return AuthService();
        },
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'twistter',
      theme:
          ThemeData(primaryColor: Colors.white, accentColor: Color(0xff55b0bd)),
      home: Splash(),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => Login(),
        '/register': (BuildContext context) => Register(),
        '/search': (BuildContext context) => Search(),
        '/followers': (BuildContext context) => Followers(),
        '/following': (BuildContext context) => Following(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
