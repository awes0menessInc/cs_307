import 'package:flutter/material.dart';
import 'package:twistter/newPost.dart';
import 'timeline.dart';
import 'profile.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Theme(
          data: ThemeData(brightness: Brightness.light),
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                "twistter",
                style: TextStyle(
                    color: Color(0xff032B30),
                    fontFamily: 'Amaranth',
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 27),
              ),
              backgroundColor: Colors.white,
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add_comment),
              backgroundColor: Color(0xff55b0bd),
              onPressed: () {
                print("hello world");
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => NewPost(),
                ));
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
                  Tab(icon: Icon(Icons.favorite), text: "Followers"),
                  Tab(icon: Icon(Icons.person), text: "Profile"),
                ],
                unselectedLabelColor: Color(0xff999999),
                labelColor: Color(0xff55b0bd),
                indicatorColor: Colors.transparent),
            body: TabBarView(
              children: [
                Timeline(),
                Center(child: Text("Page 2")),
                Center(child: Text("Page 3")),
                UserProfilePage(),
              ],
            ),
          ),
        ));
  }
}
