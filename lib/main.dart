import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:twistter/app_reducer.dart';

import 'package:twistter/app_state.dart';
import 'package:twistter/auth_middleware.dart';
import 'package:twistter/auth_service.dart';     

import 'package:twistter/register.dart';
import 'package:twistter/login.dart';
import 'package:twistter/splash.dart';
import 'package:twistter/search.dart';

void main() => runApp(
      ChangeNotifierProvider<AuthService>(
        child: MyApp(),
        builder: (BuildContext context) {
          return AuthService();
        },
      ),
    );

// void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final store = new Store<AppState>(  
    appReducer,
    initialState: new AppState(),
    middleware: []
      ..addAll(createAuthMiddleware())
      ..add(new LoggingMiddleware.printer()),
  );

  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
      store: store,
      child: new MaterialApp(
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
      )
    );
  }
}