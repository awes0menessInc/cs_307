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
import 'package:twistter/metrics.dart';

class Home extends StatefulWidget {
  Home({Key title, this.uid}) : super(key: title);
  final String uid;

  @override
  _HomeState createState() => _HomeState(uid);
}

class _HomeState extends State<Home> {
  String uid;
  Text sortText = new Text("Time");
  Icon sortButton = Icon(Icons.access_time);

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
    prefs.setBool("sort", false);
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
                  Navigator.of(context).pop();
                })
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
                    actions: <Widget>[
                      // FlatButton(
                      //   child: sortText,
                      //   onPressed: () {
                      //     setState(() {
                      //       if (sortText.data == "Time") {
                      //         setSort(true);
                      //         sortText = new Text("Relevance");
                      //       } else {
                      //         setSort(false);
                      //         sortText = new Text("Time");
                      //       }
                      //     });
                      //   },
                      // ),
                      IconButton(
                        icon: sortButton,
                        onPressed: () {
                          setState(() {
                            if (sortButton.icon.codePoint == 57746) {
                              setSort(true);
                              // sortText = new Text("Relevance");
                              sortButton = Icon(Icons.trending_up);
                            } else {
                              setSort(false);
                              // sortText = new Text("Time");
                              sortButton = Icon(Icons.access_time);
                            }
                          });
                        },
                      ),
                  // IconButton(
                  //   icon: Icon(Icons.exit_to_app, color: Colors.black),
                  //   onPressed: () {
                  //     try {
                  //       Provider.of<AuthService>(context).logout();
                  //     } on Exception catch (error) {
                  //       return buildErrorDialog(context, error.toString());
                  //     }
                  //     Navigator.pushReplacement(context,
                  //         MaterialPageRoute(builder: (context) => Login()));
                  //   },
                  // )
                ]),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.create),
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
                  // Tab(icon: Icon(Icons.home),text: "Home"),
                  // Tab(icon: Icon(Icons.search), text: "Search"),
                  // Tab(icon: Icon(Icons.person), text: "Profile"),
                  // Tab(icon: Icon(Icons.settings), text: "Settings"),

                  Tab(icon: Icon(Icons.home)),
                  Tab(icon: Icon(Icons.search)),
                  Tab(icon: Icon(Icons.person)),
                  Tab(icon: Icon(Icons.settings)),
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
