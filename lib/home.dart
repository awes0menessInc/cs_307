import 'package:flutter/material.dart';
import 'timeline.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Theme(
          data: ThemeData(brightness: Brightness.light),
          child: Scaffold(
            appBar: AppBar(
              title: Text("twistter", 
              style: TextStyle(color: Color(0xff032B30), fontFamily:'Amaranth', fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontSize: 27),
              ),
              backgroundColor: Colors.white,
              ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add_comment),
              onPressed: (){
                print("hello world");
              },),
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
                labelColor: Colors.blue,
                indicatorColor: Colors.transparent),
            body: TabBarView(
              children: [
                HomePage(),
                Center(child: Text("Page 2")),
                Center(child: Text("Page 3")),
                Center(child: Text("Page 4")),
              ],
            ),
          ),
        )
      );
  }
}
