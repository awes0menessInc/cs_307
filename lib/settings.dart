// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:twistter/timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twistter/profile.dart';

import 'login.dart';

class Settings extends StatefulWidget {
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  FirebaseUser currentUser;

  String _firstName = "";
  String _lastName = "";
  String _bio = "";
  String _email = "";
  String _bday = "";
  String _weblink = "";

  TextEditingController fnameController = new TextEditingController();
  TextEditingController lnameController = new TextEditingController();
  TextEditingController bioController = new TextEditingController();
  TextEditingController bdayController = new TextEditingController();
  TextEditingController weblinkController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  final GlobalKey<FormState> _editFormKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    _getUser();
  }

  Future _getUser() async {
     FirebaseAuth.instance.currentUser().then((currentuser) => {
      Firestore.instance.collection("users").
      document(currentuser.uid).
      get().
      then((DocumentSnapshot snapshot) => {
        setState((){
          _firstName = snapshot["firstName"];
          _lastName = snapshot["lastName"];
          _email = snapshot["email"];
        })
      })
    });
  }

  void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
  }
  
  void _logout() async {
    await FirebaseAuth.instance.signOut();
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

   void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Delete account?"),
          content: Text('Are you sure you want to delete your account? This will permanently remove all Twistter data associated with your account.'),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: new Text(
                "Delete Account",
                style: TextStyle(
                    color: Color(0xff990C04)
                )
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettings() {
    fnameController.text = _firstName;
    lnameController.text = _lastName;
    emailController.text = _email;
    return Form(
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
          Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: RaisedButton(
              child: Text(
                "Delete Account",
                style: TextStyle(
                    color: Color(0xff990C04)
                )
              ),
              onPressed: () {
                _showDialog();
              },
            ),
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Profile"),
          // Temporary Logout Button
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    _logout();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Login()));
                  },
                )
              ],
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                   _buildSettings()
                ]
              )
            )
        )
    );
  }
}