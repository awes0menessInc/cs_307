// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/rendering.dart' show debugDumpRenderTree, debugDumpLayerTree, debugDumpSemanticsTree, DebugSemanticsDumpOrder;
// import 'package:flutter/gestures.dart' show DragStartBehavior;



class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final GlobalKey<FormState> _editFormKey = GlobalKey<FormState>();
  final String _firstName = "Rebecca";
  final String _lastName = "Keys";
  final String _username = "keyspleasee";
  // final String _status = "Purdue Student";
  final String _bio =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sed odio morbi quis commodo odio. Integer eget aliquet nibh praesent tristique. Semper quis lectus nulla at volutpat diam. Fringilla est ullamcorper eget nulla facilisi etiam.";
  final String _posts = "0";
  final String _followers = "450";
  final String _following = "127";
  // String _viewingUser = "Rebecca Keys"; // currently a mock of the logged in user.
  bool pressed = false;
  bool isAccountOwner = true; //TODO: Connect to a function on the back end
  TextEditingController fnameController;
  TextEditingController lnameController;
  TextEditingController bioController;
  TextEditingController bdayController;
  TextEditingController weblinkController;
  TextEditingController emailController;

  Widget _buildProfileImage() {
    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/images/profile.jpg'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: Colors.white,
            width: 2.0,
          ),
        ),
      ),
    );
  }

  Widget _buildFullName(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        _firstName + ' ' + _lastName + ' | @'+ _username,
        style: TextStyle(
        fontFamily: 'Montserrat',
        color: Colors.black,
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
        )
      )
    );
  }

  // Widget _buildStatus(BuildContext context) {
  //   return Container(
  //     padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
  //     decoration: BoxDecoration(
  //       color: Theme.of(context).scaffoldBackgroundColor,
  //       borderRadius: BorderRadius.circular(4.0),
  //     ),
  //     child: Text(
  //       _status,
  //       style: TextStyle(
  //         fontFamily: 'Spectral',
  //         color: Colors.black,
  //         fontSize: 20.0,
  //         fontWeight: FontWeight.w300,
  //       ),
  //     ),
  //   );
  // }

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
        children: <Widget>[
          _buildStatItem("Followers", _followers),
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
        setState(() { isAccountOwner = !isAccountOwner; });
      },
      child: Text(
        'For Demo Purposes Only',
        style: TextStyle(color: Colors.red)
      )
      );
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
    if (pressed){
      return Color(0xffd1d1d1);
    } else {
      return Color(0xff077188);
    }
  }
  Text getText (bool pressed) {
    if (pressed) {
      return Text(
        'Following',
        style: TextStyle(color: Colors.black)
      );
    } else {
      return Text(
        'Follow',
        style: TextStyle(color: Colors.white)
      );
    }
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
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
                    child: getText(pressed)
                    ) 
                  )
                )
              ]
            ),
            Row(
              children: <Widget>[
                Visibility(
                  visible: isAccountOwner,
                  child: Expanded(
                    child: RaisedButton(
                      color: Color(0xffd1d1d1),
                      shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(15.0)),
                      onPressed: () {
                        showEdit(context);
                        print("Clicked edit profile");
                      }, 
                      child: Text('Edit Profile')
                  ),
                )  
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Visibility(
                visible: isAccountOwner,
                child: Expanded(
                  child: RaisedButton(
                    child: Text("Delete Account"),
                    color: Color(0xffd1d1d1),
                    shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.0)),
                    onPressed: () {
                      print("Clicked Delete");
                    },
                  ),
                ),
              )
            ],
          )
        ],
      ));
  }

  String emailValidator(String value) {
    Pattern emailPattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp emailRegex = new RegExp(emailPattern);
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid e-mail';
    } else {
      return null;
    }
  }

  String bdayValidator(String value) {
    Pattern bdayPattern = r'(0[1-9]|1[012])/(0[1-9]|[12][0-9]|3[01])/(19|20)\d\d';
    RegExp bdayRegex = new RegExp(bdayPattern);
    if (!bdayRegex.hasMatch(value)) {
      return "Enter a valid birthday";
    } else {
      return null;
    }
  }
  void showEdit(BuildContext context) { // TODO: replace with call to actual profile edit UI
    // context: context;
    // builder: (BuildContext context) {
      AlertDialog editProfile = AlertDialog(
        title: new Text("Edit Profile"),
        content: SingleChildScrollView(
          child: Form(
            key: _editFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'First Name', hintText: "John"),
                  controller: fnameController,
                  validator: (value) {
                    if (value.length == 0) {
                      return "Please enter your first name.";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Last Name', hintText: "Doe"),
                  controller: lnameController,
                  validator: (value) {
                    if (value.length == 0) {
                      return "Please enter your last name.";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email', hintText: "example@email.com"),
                  controller: emailController,
                  validator: emailValidator
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Bio', hintText: "Bio"),
                  controller: bioController,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Birthday', hintText: "10/18/2019"),
                  controller: bdayController,
                  validator: bdayValidator,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Website', hintText: "www.example.com"),
                  controller: weblinkController,
                  validator: (value) {
                    return null;
                  },
                ),
                RaisedButton(
                  child: Text("Submit"),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.black,
                  onPressed: (){
                    if (_editFormKey.currentState.validate()) {
                      
                    }
                  },
                )
              ],
            ),
          ) ,  
        )
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
    }
    else {
      return Text("$_firstName hasn't posted yet. Check back later!",
        textAlign: TextAlign.center,
        style: ts);
    }
  }

  Widget _buildNoPosts(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.all(8.0),
      child: _noPostsText()
    );
  }

  Widget _makeListTile(BuildContext context) {
    return ListTile( 
      contentPadding : EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading : Container(
        padding: EdgeInsets.only(right: 5.0),
        child: Icon(Icons.account_circle,
        size: 45.0,
        color: Color.fromRGBO(5, 62, 66, 1.0)),
      ),
      title: Text(
        "BoilerMaker",
        style: TextStyle(color: Color.fromRGBO(7, 113, 136, 1.0), fontWeight: FontWeight.bold, fontSize: 12),
      ),
      subtitle: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
      style: TextStyle(fontSize: 11)),

      trailing: Row(
        mainAxisSize : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(Icons.favorite,
          size: 20.0),
          Icon(Icons.add_comment,
          size: 20.0)
        ]
      ),
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
                  _buildDemoButton(),
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