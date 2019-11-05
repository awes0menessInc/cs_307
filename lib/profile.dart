// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
// import 'package:twistter/currentUserInfo.dart';
import 'package:twistter/timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {

  String _firstName;
  String _username;
  String _lastName;
  String _posts = "1";
  String _followers;
  String _following;
  String _email;
  String _bio;
  
  // String _viewingUser = "Rebecca Keys"; // currently a mock of the logged in user.
  bool pressed = false;
  bool isAccountOwner = true; //TODO: Connect to a function on the back end
  // CurrentUserInfo cui;

  @override
  initState() {
    // print('Creating new instance of CurrentUserInfo class');
    // cui = new CurrentUserInfo();
    this.getUserInfo();
    super.initState();
  }

  Timeline t = new Timeline();

  void getUserInfo() async{
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print('current user is '+ user.uid);
    var userQuery = Firestore.instance.collection('users').where('uid', isEqualTo: user.uid).limit(1);
    userQuery.getDocuments().then((data){ 
    if (data.documents.length > 0){
      setState(() {
        _firstName = data.documents[0].data['firstName'];
        _lastName = data.documents[0].data['lastName'];
        _email = data.documents[0].data['email'];
        _username = data.documents[0].data['username'];
        _bio = data.documents[0].data['bio'];
        _followers = data.documents[0].data['followers'].toString();
        _following = data.documents[0].data['following'].toString();
        // _posts = data.documents[0].data['microblogs'].length().toString();
      });}
    });
  }

  String getUsername() {
    return _username;
  }

  Widget _buildProfileImage() {
    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        child: new Container(
          decoration: new BoxDecoration(
            color: Color(0xff55b0bd),
            borderRadius: BorderRadius.circular(80.0),
          ),
          child: Center(
            child: Text('${_firstName[0]}' + '${_lastName[0]}',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 50.0)),
            // TODO: Add functionality to display profile picture if the user has uploaded one
            // decoration: BoxDecoration(
            //   // image: DecorationImage(
            //   //   image: AssetImage('lib/assets/images/profile.jpg'),
            //     // fit: BoxFit.cover,
            //   ),
            //   borderRadius: BorderRadius.circular(80.0),
            //   border: Border.all(
            //     color: Colors.white,
            //     width: 2.0,
            //   ),
            // ),
          ),
        ),
      ),
    );
  }

  Widget _buildFullName(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Text('$_firstName' + ' ' + _lastName + ' | @' + _username,
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
            )));
  }

  Widget _buildStatItem(String label, String count) {
    TextStyle _statLabelTextStyle = TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.black,
      fontSize: 16.0,
      fontWeight: FontWeight.w200,
    );

    TextStyle _statCountTextStyle = TextStyle(
      color: Colors.black54,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count,
          style: _statCountTextStyle,
        ),
        Text(
          label,
          style: _statLabelTextStyle,
        ),
      ],
    );
  }

  Widget _buildStatContainer() {
    return Container(
      height: 60.0,
      margin: EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        color: Color(0xFFEFF4F7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        // StreamBuilder(
        //   stream: Firestore.instance.collection('users').snapshots(),
        //   builder: (context, snapshot) {
        //     return _buildStatItem("Followers", snapshot.data.document['followers']);
        //   },
        // ),
        children: <Widget>[
          _buildStatItem("Followers",
              _followers), //userDoc is the document in Firestore of the currently logged in user
          // TODO: Add a function that gets the name of the doucment for the currently logged in user and stores it as 'userdoc' (match uid to the right doc)
          _buildStatItem("Following", _following),
          _buildStatItem("Posts", _posts),
        ],
      ),
    );
  }

  Widget _buildDemoButton() {
    return FlatButton(
        color: Colors.white,
        onPressed: () {
          setState(() {
            isAccountOwner = !isAccountOwner;
          });
        },
        child: Text('For Demo Purposes Only',
            style: TextStyle(color: Colors.red)));
  }

  Widget _buildBio(BuildContext context) {
    TextStyle bioTextStyle = TextStyle(
      fontFamily: 'Spectral',
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic,
      color: Color(0xFF799497),
      fontSize: 16.0,
    );
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.all(8.0),
      child: Text(
        _bio,
        textAlign: TextAlign.center,
        style: bioTextStyle,
      ),
    );
    }

  Widget _buildSeparator(Size screenSize) {
    return Container(
      width: screenSize.width / 1.2,
      height: 2.0,
      color: Colors.black54,
      margin: EdgeInsets.only(top: 4.0),
    );
  }

  Color getColor(bool pressed) {
    if (pressed) {
      return Color(0xffd1d1d1);
    } else {
      return Color(0xff077188);
    }
  }

  Text getText(bool pressed) {
    if (pressed) {
      return Text('Following', style: TextStyle(color: Colors.black));
    } else {
      return Text('Follow', style: TextStyle(color: Colors.white));
    }
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              Visibility(
                  visible: !isAccountOwner,
                  child: Expanded(
                      child: RaisedButton(
                          color: getColor(pressed),
                          onPressed: () {
                            setState(() {
                              pressed = !pressed;
                            });
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(15.0)),
                          child: getText(pressed))))
            ]),
            // Row(
            //   children: <Widget>[
            //     Visibility(
            //       visible: isAccountOwner,
            //       child: Expanded(
            //         child: RaisedButton(
            //           child: Text("Delete Account"),
            //           color: Color(0xffd1d1d1),
            //           shape: RoundedRectangleBorder(
            //               borderRadius: new BorderRadius.circular(15.0)),
            //           onPressed: () {
            //             print("Clicked Delete");
            //           },
            //         ),
            //       ),
            //     )
            //   ],
            // )
          ],
        ));
  }

  static void showEdit(BuildContext context) {
    // TODO: replace with call to actual profile edit UI
    // context: context;
    // builder: (BuildContext context) {
    AlertDialog editProfile = AlertDialog(
      title: new Text("Edit Profile"),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 30.0, right: 60.0),
              child: TextFormField(
                decoration: new InputDecoration(hintText: 'First Name'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0, right: 60.0),
              child: TextFormField(
                decoration: new InputDecoration(hintText: 'Last Name'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0, right: 60.0),
              child: TextFormField(
                decoration: new InputDecoration(hintText: 'Email '),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0, right: 60.0),
              child: TextFormField(
                decoration: new InputDecoration(hintText: 'Bio'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: RaisedButton(
                child: Text("Submit"),
                onPressed: () {
                  Navigator.pop(context);
                  print("Submitted Pofile Edits"); // TODO: Connect to back end
                },
              ),
            ),
          ],
        ),
      ),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return editProfile;
      },
    );
  }

  Text _noPostsText() {
    TextStyle ts = TextStyle(
      fontFamily: 'Spectral',
      fontWeight: FontWeight.w400,
      color: Color(0xFF799497),
      fontSize: 16.0,
    );

    if (isAccountOwner) {
      return Text(
          "You haven't posted yet. Click the new post button to create your first post!",
          textAlign: TextAlign.center,
          style: ts);
    } else {
      return Text("$_firstName hasn't posted yet. Check back later!",
          textAlign: TextAlign.center, style: ts);
    }
  }

  Widget _buildNoPosts(BuildContext context) {
    return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: EdgeInsets.all(8.0),
        child: _noPostsText());
  }

  Widget _makeListTile(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 5.0),
        child: Icon(Icons.account_circle,
            size: 45.0, color: Color.fromRGBO(5, 62, 66, 1.0)),
      ),
      title: Text(
        "BoilerMaker",
        style: TextStyle(
            color: Color.fromRGBO(7, 113, 136, 1.0),
            fontWeight: FontWeight.bold,
            fontSize: 12),
      ),
      subtitle: Text(
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
          style: TextStyle(fontSize: 11)),
      trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(Icons.favorite, size: 20.0),
            Icon(Icons.add_comment, size: 20.0)
          ]),
    );
  }

  Widget _makeBody(BuildContext context) {
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          _makeCard(context);
        },
      ),
    );
  }

  Widget _makeCard(BuildContext context) {
    return Card(
      elevation: 8.0,
      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: _makeListTile(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // getInfo();
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // _buildCoverImage(screenSize),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: screenSize.height / 20),
                  _buildProfileImage(),
                  SizedBox(height: 10.0),
                  _buildFullName(context),
                  // _buildStatus(context),
                  _buildStatContainer(),
                  _buildBio(context),
                  _buildSeparator(screenSize),
                  // _buildDemoButton(),
                  _buildButtons(context),
                  _buildNoPosts(context),
                  _makeBody(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
