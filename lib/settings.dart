// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:twistter/timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Settings extends StatefulWidget {
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  Widget _buildSettings() {
        return Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 30.0, right: 60.0),
                child: TextFormField(
                  decoration: new InputDecoration(
                    hintText: 'First Name'
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20.0, right: 60.0),
                child: TextFormField(
                  decoration: new InputDecoration(
                    hintText: 'Last Name'
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20.0, right: 60.0),
                child: TextFormField(
                  decoration: new InputDecoration(
                    hintText: 'Email '
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20.0, right: 60.0),
                child: TextFormField(
                  minLines: 3,
                  maxLines: 5,
                  maxLength: 150,
                  decoration: new InputDecoration(
                    hintText: 'Bio'
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: RaisedButton(
                  child: Text("Save Changes"),
                  onPressed: () {
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