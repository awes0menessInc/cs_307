// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart' show debugDumpRenderTree, debugDumpLayerTree, debugDumpSemanticsTree, DebugSemanticsDumpOrder;
// import 'package:flutter/gestures.dart' show DragStartBehavior;

bool pressed = false;

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final String _fullName = "Rebecca Keys";
  final String _status = "Purdue Student";
  final String _bio =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sed odio morbi quis commodo odio. Integer eget aliquet nibh praesent tristique. Semper quis lectus nulla at volutpat diam. Fringilla est ullamcorper eget nulla facilisi etiam.";
  final String _posts = "24";
  final String _followers = "450";
  final String _following = "127";
  String _viewingUser = "FirstnameLastName"; // currently a mock of the logged in user.

  Widget _buildProfileImage() {
    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/images/profile_image.jpg'),
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
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
    );

    return Text(
      _fullName,
      style: _nameTextStyle,
    );
  }

  Widget _buildStatus(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        _status,
        style: TextStyle(
          fontFamily: 'Spectral',
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    TextStyle _statLabelTextStyle = TextStyle(
      fontFamily: 'Roboto',
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

  Widget _buildBio(BuildContext context) {
    TextStyle bioTextStyle = TextStyle(
      fontFamily: 'Spectral',
      fontWeight: FontWeight.w400, //try changing weight to w500 if not thin
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
      width: screenSize.width / 1.6,
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
    // bool isAccountOwner = (_fullName == _viewingUser);
    bool isAccountOwner = true;
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
        ],
      ));
  }

  showAlertDialog(BuildContext context) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () { },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("My title"),
    content: Text("This is my message."),
    actions: [
      okButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

  AlertDialog showEdit(BuildContext context) { // TODO: replace with call to actual profile edit UI
    // context: context;
    // builder: (BuildContext context) {
      AlertDialog editProfile = AlertDialog(
        title: new Text("Edit Profile"),
        content: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: new InputDecoration(
                    hintText: 'Bio'
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: new InputDecoration(
                    hintText: 'First Name'
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: new InputDecoration(
                    hintText: 'Last Name'
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: new InputDecoration(
                    hintText: 'Email '
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text("Submit"),
                  onPressed: () {
                    Navigator.pop(context);
                    print("Submitted Pofile Edits"); // TODO: Connect to back end
                  },
                ),
              )
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
                  _buildFullName(context),
                  _buildStatus(context),
                  _buildStatContainer(),
                  _buildBio(context),
                  _buildSeparator(screenSize),
                  SizedBox(height: 10.0),
                  SizedBox(height: 8.0),
                  _buildButtons(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}