import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twistter/newPost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twistter/timeline.dart';
import 'package:twistter/profile.dart';
import 'package:twistter/settings.dart';
import 'package:twistter/newPost.dart';
import 'package:twistter/search.dart';
import 'package:twistter/user.dart';

class Home extends StatefulWidget {
  Home({Key title, this.uid, this.current_user}) : super(key: title); 
  final String uid;
  User current_user;

  @override
  _HomeState createState() => _HomeState();

  User getUser() {
    return current_user;
  }
}

class _HomeState extends State<Home> {
  static FirebaseUser currentUser;
  String username;
  String firstName;
  String lastName;
  String email;
  String bio;
  String followers;
  String following;
  // static User current_user;
  
  @override
  void initState() {
    this.getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
    var userQuery = Firestore.instance.collection('users').where('uid', isEqualTo: currentUser.uid).limit(1);
    userQuery.getDocuments().then((data){ 
      if (data.documents.length > 0){
        setState(() {
          // current_user = current;
          // widget.current_user.uid = currentUser.uid;
          // widget.current_user.username = data.documents[0].data['username'];
          // widget.current_user.firstName = data.documents[0].data['firstName'];
          // widget.current_user.lastName = data.documents[0].data['lastName'];
          // widget.current_user.email = data.documents[0].data['email'];
          // widget.current_user.bio = data.documents[0].data['bio'];
          // widget.current_user.birthday = data.documents[0].data['birthday'];
          // widget.current_user.website = data.documents[0].data['website'];

          // widget.current_user.numFollowing = data.documents[0].data['following'].toString();
          // widget.current_user.numFollowers = data.documents[0].data['followers'].toString();
          // _posts = data.documents[0].data['microblogs'].length().toString();


          firstName = data.documents[0].data['firstName'];
          lastName = data.documents[0].data['lastName'];
          email = data.documents[0].data['email'];
          username = data.documents[0].data['username'];
          bio = data.documents[0].data['bio'];
          followers = data.documents[0].data['followers'].toString();
          following = data.documents[0].data['following'].toString();
          // _posts = data.documents[0].data['microblogs'].length().toString();
        });
      }
    });
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
        ));
  }
}
