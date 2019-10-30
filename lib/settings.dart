// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:twistter/timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twistter/profile.dart';

class Settings extends StatefulWidget {
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
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
<<<<<<< HEAD
              Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: RaisedButton(
                  child: Text("Save Changes"),
                  onPressed: () {
                    final snackBar = SnackBar(
                      content: Text('Success! Your profile edits were submitted.'),
                      duration: const Duration(seconds: 10),
                      action: SnackBarAction(
                        label: 'Dismiss',
                        onPressed: () {
                          Scaffold.of(context).hideCurrentSnackBar();
                        },
                      ),
                    );
                    Scaffold.of(context).showSnackBar(snackBar); // TODO: Connect to back end
                  },
                ),
=======
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Website', hintText: "www.example.com"),
                controller: weblinkController,
                validator: (value) {
                  return null;
                },
>>>>>>> 8e248114f3c6e653c4a5cf1ff296147cece5e332
              ),
          Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: RaisedButton(
              child: Text("Save Changes"),
              onPressed: () {
                // TODO: call cloud functions
                if (_editFormKey.currentState.validate()) {
                  final snackBar = SnackBar(
                    content: Text('Profile changes saved successfully'),
                    duration: const Duration(seconds: 10),
                    action: SnackBarAction(
                      label: 'Dismiss',
                      onPressed: () {
                        Scaffold.of(context).hideCurrentSnackBar();
                      },
                    ),
                  );
                  Scaffold.of(context).showSnackBar(snackBar);
                  print("Submitted Pofile Edits"); // TODO: Connect to back end   
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: RaisedButton(
              child: Text("Delete Account"),
              onPressed: () {
                
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
          title: Text("Edit Profile")
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