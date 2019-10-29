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
      return 'Please enter a valid e-mail';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    // Pattern passwordPattern = r'(?=.{8,})';
    // RegExp passwordRegex = new RegExp(passwordPattern)
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  String usernameValidator (String username) {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _registerFormKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'First Name*', hintText: "John"),
                  controller: firstNameInputController,
                  validator: (value) {
                    if (value.length == 0) {
                      return "Please enter your first name.";
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Last Name*', hintText: "Doe"),
                  controller: lastNameInputController,
                  validator: (value) {
                    if (value.length == 0) {
                      return "Please enter your last name.";
                    }
                  }
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Username*'),
                  controller: usernameInputController,
                  validator: (value) {
                    if (value.length < 8) {
                      return "Please enter a valid username";
                    }
                  }
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email*', hintText: "john.doe@gmail.com"),
                  controller: emailInputController,
                  keyboardType: TextInputType.emailAddress,
                  validator: emailValidator,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password*', hintText: "********"),
                  controller: pwdInputController,
                  obscureText: true,
                  validator: pwdValidator,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Confirm Password*', hintText: "********"),
                  controller: confirmPwdInputController,
                  obscureText: true,
                  validator: pwdValidator,
                ),
                RaisedButton(
                  child: Text("Register"),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.black,
                  onPressed: () {
                    if (_registerFormKey.currentState.validate()) {
                      if (pwdInputController.text == confirmPwdInputController.text) {
                        FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: emailInputController.text,
                          password: pwdInputController.text)
                          .then((currentUser) => Firestore.instance
                          .collection("users")
                          .document(currentUser.uid).setData({
                            "uid": currentUser.uid,
                            "firstName": firstNameInputController.text,
                            "lastName": lastNameInputController.text,
                            "email": emailInputController.text,
                          })
                          .then((result) => {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Home(
                                  uid: currentUser.uid,
                                )
                              ),
                              (_) => false),
                              firstNameInputController.clear(),
                              lastNameInputController.clear(),
                              usernameInputController.clear(),
                              emailInputController.clear(),
                              pwdInputController.clear(),
                              confirmPwdInputController.clear()
                          }).catchError((err) => print(err))
                        ).catchError((err) => print(err));
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