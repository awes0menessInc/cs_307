import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twistter/auth_service.dart';
import 'package:twistter/login.dart';

import 'package:twistter/newPost.dart';
import 'package:twistter/timeline.dart';
import 'package:twistter/profile.dart';
import 'package:twistter/settings.dart';
import 'package:twistter/search.dart';

class Home extends StatefulWidget {
  Home({Key title, this.uid}) : super(key: title);
  final String uid;

  @override
  _HomeState createState() => _HomeState(uid);
}

class _HomeState extends State<Home> {
  String uid;
  Text sortText = new Text("Time");
  _HomeState(this.uid);
  @override
  void initState() {
    AuthService.initUser(uid);
    _setUser();
    super.initState();
  }

  _setUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user", uid);
  }

  Future buildErrorDialog(BuildContext context, message) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                // pwdInputController.clear();
                Navigator.of(context).pop();
              }
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Theme(
          data: ThemeData(brightness: Brightness.light),
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "twistter",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Amaranth',
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 27),
              ),
              backgroundColor: Color.fromRGBO(85, 176, 189, 1.0),
              actions: <Widget> [
                FlatButton(
                  child: sortText,
                  onPressed: () {
                    setState(() {
                      if (sortText.data == "Time") {
                        sortText = new Text("Relevance");
                      } else {
                        sortText = new Text("Time");
                      }
                      //TODO: somehow connect to sort
                    });
                    
                  },
                ),
                IconButton(
                  icon: Icon(Icons.exit_to_app, color: Colors.black),
                  onPressed: () {
                    try {
                      Provider.of<AuthService>(context).logout();
                    } on Exception catch (error) {
                      return buildErrorDialog(context, error.toString());
                    }
                    // _logout();


                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => Login()));
                  },
                )
              ]
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add_comment),
              backgroundColor: Color(0xff55b0bd),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewPost()),
                );
              },
            ),
            bottomNavigationBar: TabBar(
                tabs: [
                  Tab(
                    icon: Icon(
                      Icons.home,
                    ),
                    text: "Home",
                  ),
                  Tab(icon: Icon(Icons.search), text: "Search"),
                  Tab(icon: Icon(Icons.person), text: "Profile"),
                  Tab(icon: Icon(Icons.settings), text: "Settings"),
                ],
                unselectedLabelColor: Color(0xff999999),
                labelColor: Color(0xff55b0bd),
                indicatorColor: Colors.transparent),
            body: TabBarView(
              children: [
                Timeline(),
                Search(),
                ProfilePage(),
                Settings(),
              ],
            ),
          ),
        ));
  }
}
