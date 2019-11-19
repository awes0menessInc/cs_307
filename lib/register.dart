import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home.dart';

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController firstNameInputController;
  TextEditingController lastNameInputController;
  TextEditingController usernameInputController;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;

  @override
  initState() {
    firstNameInputController = new TextEditingController();
    lastNameInputController = new TextEditingController();
    usernameInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    confirmPwdInputController = new TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern emailPattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp emailRegex = new RegExp(emailPattern);
    if (!emailRegex.hasMatch(value)) {
      return 'Invalid email address';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    // Pattern passwordPattern = r'(?=.{8,})';
    // RegExp passwordRegex = new RegExp(passwordPattern)
    if (value.length <= 8) {
      return 'Password must be at least 8 characters';
    } else {
      return null;
    }
  }

  String confirmPwdValidator (String value) {
    if (value != pwdInputController.text) {
      return 'Passwords must match';
    }
    else {
      return null;
    }
  }

  String usernameValidator (String username) {
    if (username.length == 0) {
      return "Please enter a username";
    }
    else {
      // final QuerySnapshot query = await Firestore.instance.collection('users').where('username', isEqualTo: username).limit(1).getDocuments();
      Firestore.instance.collection('users').where('username', isEqualTo: username).getDocuments()
      .then((QuerySnapshot snapshot) => () {
        List<DocumentSnapshot> documents = snapshot.documents;
        if (documents.length == 1) {
          return "Username already exists";
        }
        else {
          return "Username valid!";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _registerFormKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'First Name*', hintText: "John"),
                  controller: firstNameInputController,
                  validator: (value) {
                    if (value.length == 0) {
                      return "Please enter your first name";
                    }
                    else return null;
                  },
                  autovalidate: true,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Last Name*', hintText: "Doe"),
                  controller: lastNameInputController,
                  validator: (value) {
                    if (value.length == 0) {
                      return "Please enter your last name";
                    }
                    else return null;
                  },
                  autovalidate: true,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Username*'),
                  controller: usernameInputController,
                  validator: usernameValidator,
                  autovalidate: true,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email*', hintText: "john.doe@gmail.com"),
                  controller: emailInputController,
                  keyboardType: TextInputType.emailAddress,
                  validator: emailValidator,
                  autovalidate: true,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password*', hintText: "********"),
                  controller: pwdInputController,
                  obscureText: true,
                  validator: pwdValidator,
                  autovalidate: true,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Confirm Password*', hintText: "********"),
                  controller: confirmPwdInputController,
                  obscureText: true,
                  validator: confirmPwdValidator,
                  autovalidate: true,
                ),
                RaisedButton(
                  child: Text("Register"),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.black,
                  onPressed: () {
                    if (_registerFormKey.currentState.validate()) {
                      if (pwdInputController.text == confirmPwdInputController.text) {
                        FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: emailInputController.text,
                              password: pwdInputController.text)
                          .catchError((err) => showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Registration failed"),
                                content: Text('An account already exists with the email address you entered.'),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("Close"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            }))
                              .then((currentUser) => Firestore.instance
                                .collection("users").document(currentUser.uid)
                                .setData({
                                    "uid": currentUser.uid,
                                    "firstName": firstNameInputController.text,
                                    "lastName": lastNameInputController.text,
                                    "username": usernameInputController.text,
                                    "email": emailInputController.text,
                                    "followers": 1,
                                    "bio": "",
                                    "followingList": FieldValue.arrayUnion(
                                        [currentUser.uid.toString()]),
                                })
                                .then((result) => {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => Home(
                                                          uid: currentUser.uid,
                                                        )),
                                                (_) => false),
                                            firstNameInputController.clear(),
                                            lastNameInputController.clear(),
                                            usernameInputController.clear(),
                                            emailInputController.clear(),
                                            pwdInputController.clear(),
                                            confirmPwdInputController.clear()
                                          }))
                              .catchError((err) => print(err))
                              .catchError((err) => print(err));
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Error"),
                                  content: Text("The passwords do not match"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Close"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              });
                        }
                      }
                    },
                  ),
                  Text("Already have an account?"),
                  FlatButton(
                    child: Text("Click here to Login"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ))));
  }
}
