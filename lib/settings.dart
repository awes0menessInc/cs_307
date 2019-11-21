import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  String _birthday;
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

  @override
  initState() {
    getUser();
    super.initState();
  }

  Future getUser() async {
     await FirebaseAuth.instance.currentUser().then((currentuser) => {
      Firestore.instance.collection("users")
      .document(currentuser.uid).get()
      .then((DocumentSnapshot snapshot) => {
        setState((){
          _firstName = snapshot["firstName"];
          _lastName = snapshot["lastName"];
          _email = snapshot["email"];
          _uid = snapshot["uid"];
          _topics = List.from(snapshot["topics"]);
          if (snapshot.data.containsKey("uid")) {
            _bio = snapshot["bio"];
          }
          if (snapshot.data.containsKey("website")) {
            _website = snapshot["website"];
          }
          if (snapshot.data.containsKey("birthday")) {
            _birthday = snapshot["birthday"];
          }
        })
      })
    });
  }

  // void getUser() {
  //   this._uid = AuthService.getUserInfo().uid;
  //   this._firstName = AuthService.getUserInfo().firstName;
  //   this._lastName = AuthService.getUserInfo().lastName;
  //   this._email = AuthService.getUserInfo().email;
  //   this._bio = AuthService.getUserInfo().bio;
  //   this._website = AuthService.getUserInfo().website;
  //   this._birthday = AuthService.getUserInfo().birthday;
  // }

  Future deleteUser() async {
    Firestore.instance.collection("users").document(_uid).delete();
    FirebaseAuth.instance.currentUser().then((currentUser) => {
      currentUser.delete()
    });
  }

  Future deleteMicroblogs() async {
    await Firestore.instance.collection("microblogs").getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => {
        if (f.data["userId"] == _uid) {
          print(f.documentID),
          Firestore.instance.collection("microblogs").document(f.documentID).delete()
        }
      });
    });
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
    Pattern bdayPattern =
        r'(0[1-9]|1[012])/(0[1-9]|[12][0-9]|3[01])/(19|20)\d\d';
    RegExp bdayRegex = new RegExp(bdayPattern);
    if (!bdayRegex.hasMatch(value)) {
      return "Enter a valid date";
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
              child: new Text("Delete Account",
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
    bdayController.text = _birthday;
    bioController.text = _bio;
    websiteController.text = _website;
    return Form(
      key: _editFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: 'First Name', hintText: "John"),
            controller: fnameController,
            onSaved: (value) {
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
            decoration: InputDecoration(
              labelText: 'Last Name', hintText: "Doe"),
            controller: lnameController,
            onSaved: (value) {
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
            decoration: InputDecoration(
              labelText: 'Email', hintText: "example@email.com"),
            controller: emailController,
            onSaved: (value) {
              AuthService.currentUser.email = value;
            },
            validator: emailValidator
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Bio', hintText: "Bio"),
            controller: bioController,
            onSaved: (value) {
              AuthService.currentUser.bio = value;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Birthday', hintText: "10/18/2019"),
            controller: bdayController,
            onSaved: (value) {
              AuthService.currentUser.birthday = value;
            },
            validator: bdayValidator,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Website', hintText: "www.example.com"),
            controller: websiteController,
            onSaved: (value) {
              AuthService.currentUser.website = value;
            },
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: RaisedButton(
              child: Text("Save"),
              onPressed: () {
                setState(() {
                  _topics.add(topicController.text);
                });
                if (_editFormKey.currentState.validate()) {
                  _editFormKey.currentState.save();
                  Firestore.instance.collection("users").document(_uid).updateData({
                    "firstName": fnameController.text,
                    "lastName": lnameController.text,
                    "email": emailController.text,
                    "bio": bioController.text,
                    "birthday": bdayController.text,
                    "website": websiteController.text,
                    "uid": _uid,
                    "topics": _topics,
                  });
                  AuthService.updateUser(
                    fnameController.text,
                    lnameController.text,
                    emailController.text,
                    bioController.text,
                    bdayController.text,
                    websiteController.text,
                    _topics,
                  );
                  final snackBar = SnackBar(
                    content: Text('Profile changes saved successfully'),
                    duration: const Duration(seconds: 3),
                    action: SnackBarAction(
                      label: 'Dismiss',
                      onPressed: () {
                        Scaffold.of(context).hideCurrentSnackBar();
                      },
                    ),
                  );
                  Scaffold.of(context).showSnackBar(snackBar);
                }
              }
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: RaisedButton(
              child: Text(
                "Delete Account",
                style: TextStyle(
                    color: Color(0xff990C04)
                )
              ),
              onPressed: () {
                buildDeleteDialog();
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
            child: buildSettingsForm(),)));
            // child: Column(children: <Widget>[buildSettingsForm()]))));
  }
}
