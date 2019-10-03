import 'package:flutter/material.dart';
import 'package:twistter/newPost.dart';
import 'timeline.dart';
import 'profile.dart';
// import 'profile_copy.dart';
import 'newPost.dart';

class Home extends StatelessWidget {
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
                ProfilePage(),
              ],
            ),
          ),
        ));
  }
}
