import 'package:flutter/material.dart';
import 'package:twistter/auth_service.dart';

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
  _HomeState(this.uid);
  @override
  void initState() {
    super.initState();
    AuthService.initUser(uid);
  }

  @override
  Widget build (BuildContext context) {
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
              Tab(icon: Icon(Icons.home,),text: "Home",),
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
      )
    );
  }
}
