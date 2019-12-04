import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

import 'package:twistter/auth_service.dart';
import 'package:twistter/login.dart';

class Settings extends StatefulWidget {
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  FirebaseUser currentUser;

  String _firstName;
  String _lastName;
  String _bio;
  String _email;
  DateTime _birthday;
  String _website;
  String _uid;
  List<String> _topics;

  TextEditingController fnameController = new TextEditingController();
  TextEditingController lnameController = new TextEditingController();
  TextEditingController bioController = new TextEditingController();
  TextEditingController bdayController = new TextEditingController();
  TextEditingController websiteController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController topicController = new TextEditingController();
  final GlobalKey<FormState> _editFormKey = GlobalKey<FormState>();
  bool _emailIsPrivate;

  @override
  initState() {
    getUser();
    super.initState();
  }

  // Future _getUser() async {
  //   await FirebaseAuth.instance.currentUser().then((currentuser) => {
  //   Firestore.instance
  //   .collection("users")
  //   .document(currentuser.uid)
  //   .get()
  //   .then((DocumentSnapshot snapshot) => {
  //         setState(() {
  //           _firstName = snapshot["firstName"];
  //           _lastName = snapshot["lastName"];
  //           _email = snapshot["email"];
  //           _uid = snapshot["uid"];
  //           _emailIsPrivate = snapshot["emailIsPrivate"];
  //           print(_emailIsPrivate);
  //           _topics = List.from(snapshot["topics"]);
  //           if (snapshot.data.containsKey("uid")) {
  //             _bio = snapshot["bio"];
  //           }
  //           if (snapshot.data.containsKey("website")) {
  //             _website = snapshot["website"];
  //           }
  //           if (snapshot.data.containsKey("birthday")) {
  //             _birthday = snapshot["birthday"];
  //           }
  //         })
  //       })
  //     }
  //   );
  // }

  void getUser() {
    _uid = AuthService.currentUser.uid;
    _firstName = AuthService.currentUser.firstName;
    _lastName = AuthService.currentUser.lastName;
    _email = AuthService.currentUser.email;
    _bio = AuthService.currentUser.bio;
    _website = AuthService.currentUser.website;
    _birthday = AuthService.currentUser.birthday;
    _topics = AuthService.currentUser.topicsList;
    _emailIsPrivate = AuthService.currentUser.emailIsPrivate;
  }

  Future deleteUser() async {
    Firestore.instance.collection("users").document(_uid).delete();
    FirebaseAuth.instance
        .currentUser()
        .then((currentUser) => {currentUser.delete()});
  }

  Future deleteMicroblogs() async {
    await Firestore.instance
        .collection("posts")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => {
            if (f.data["uid"] == _uid)
              {
                print(f.documentID),
                Firestore.instance
                    .collection("posts")
                    .document(f.documentID)
                    .delete()
              }
          });
    });
  }

  void _logout() async {
    AuthService.currentUser = null;
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

  void buildDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete account?"),
          content: Text(
              'Are you sure you want to delete your account? This will permanently remove all Twistter data associated with your account.'),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: new Text("Delete",
                  style: TextStyle(color: Color(0xff990C04))),
              onPressed: () {
                deleteUser();
                deleteMicroblogs();
                Navigator.pushReplacementNamed(context, "/login");
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildSettingsForm() {
    fnameController.text = _firstName;
    lnameController.text = _lastName;
    emailController.text = _email;
    bioController.text = _bio;
    bdayController.text = _birthday.toString();
    websiteController.text = _website;

    return Form(
        key: _editFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'First Name', hintText: _firstName),
              controller: fnameController,
              onSaved: (value) {
                // fnameController.text = value;
                AuthService.currentUser.firstName = value;
              },
              validator: (value) {
                if (value.length == 0) {
                  return "Please enter your first name";
                }
                return null;
              },
            ),
            TextFormField(
              decoration:
                  InputDecoration(labelText: 'Last Name', hintText: _lastName),
              controller: lnameController,
              onSaved: (value) {
                // lnameController.text = value;
                AuthService.currentUser.lastName = value;
              },
              validator: (value) {
                if (value.length == 0) {
                  return "Please enter your last name";
                }
                return null;
              },
            ),
            TextFormField(
                decoration:
                    InputDecoration(labelText: 'Email', hintText: _email),
                controller: emailController,
                onSaved: (value) {
                  // emailController.text = value;
                  AuthService.currentUser.email = value;
                },
                validator: emailValidator),
            TextFormField(
              decoration: InputDecoration(labelText: 'Bio', hintText: _bio),
              controller: bioController,
              onSaved: (value) {
                // bioController.text = value;
                AuthService.currentUser.bio = value;
              },
            ),
            DateTimeField(
              controller: bdayController,
              format: DateFormat("yyyy-MM-dd"),
              decoration: InputDecoration(labelText: 'Birthday',),
              onShowPicker: (context, currentValue) {
                return showDatePicker(
                    context: context,
                    firstDate: DateTime(1930),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100));
              },
              onSaved: (value) {
                AuthService.currentUser.birthday = value;
              },
            ),
            TextFormField(
              decoration:
                  InputDecoration(labelText: 'Website', hintText: _website),
              controller: websiteController,
              onSaved: (value) {
                // websiteController.text = value;
                AuthService.currentUser.website = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Add a Topic', hintText: _topics.toString()),
              controller: topicController,
              // validator: (value) {
              //   if (value == null || value.isEmpty || _topics.contains(value)) {
              //     return "Topic not valid.";
              //   }
              //   return null;
              // },
              onSaved: (value) {
                _topics.add(value);
              },
            ),
            Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(children: <Widget>[
                  Text('Hide email from other users',
                      style: TextStyle(fontSize: 16)),
                  Expanded(
                      child: Container(
                          alignment: Alignment.centerRight,
                          child: Switch(
                            value: _emailIsPrivate,
                            onChanged: (value) {
                              AuthService.currentUser.emailIsPrivate = value;
                              setState(() {
                                _emailIsPrivate = value;
                                print(_emailIsPrivate.toString());
                              });
                            },
                            activeTrackColor: Color(0xff55B0BD),
                            activeColor: Color(0xff077188),
                          ))),
                ])),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: RaisedButton(
                  child: Text("Save"),
                  onPressed: () {
                    // setState(() {
                    //   _topics.add(topicController.text);
                    // });
                    if (_editFormKey.currentState.validate()) {
                      _editFormKey.currentState.save();
                      Firestore.instance
                          .collection("users")
                          .document(_uid)
                          .updateData({
                        "firstName": fnameController.text,
                        "lastName": lnameController.text,
                        "email": emailController.text,
                        "bio": bioController.text,
                        "birthday": _birthday.toUtc(),
                        "website": websiteController.text,
                        "uid": _uid,
                        "topicsList": List.from(_topics),
                        "emailIsPrivate": _emailIsPrivate,
                      });
                      final snackBar = SnackBar(
                        content: Text('Profile changes saved successfully'),
                        duration: const Duration(seconds: 3),
                        action: SnackBarAction(
                          textColor: Color(0xff55B0BD),
                          label: 'Dismiss',
                          onPressed: () {
                            Scaffold.of(context).hideCurrentSnackBar();
                          },
                        ),
                      );
                      Scaffold.of(context).showSnackBar(snackBar);
                    }
                    setState(() {
                      print("refresh settings");
                      fnameController.clear();
                      lnameController.clear();
                      bioController.clear();
                      bdayController.clear();
                      websiteController.clear();
                      emailController.clear();
                      topicController.clear();
                    });
                  }),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: RaisedButton(
                child: Text("Delete Account",
                    style: TextStyle(color: Color(0xff990C04))),
                onPressed: () {
                  buildDeleteDialog();
                },
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Profile", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app, color: Colors.black),
              onPressed: () {
                _logout();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
            )
          ],
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: buildSettingsForm(),
            )));
  }
}
