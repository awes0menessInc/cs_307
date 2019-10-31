import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;

  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _loginFormKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email', hintText: "john.doe@gmail.com"),
                    controller: emailInputController,
                    keyboardType: TextInputType.emailAddress,
                    validator: emailValidator,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password', hintText: "********"),
                    controller: pwdInputController,
                    obscureText: true,
                    validator: pwdValidator,
                ),
                FlatButton(
                  child: Text(
                    "Forgot password?",
                    style: TextStyle(
                      color: Colors.lightBlue,
                      fontSize: 11,
                    )
                  ),
                  /* TODO: implement forgot password function */
                  onPressed: () => null,
                ),
                RaisedButton(
                  child: Text("Login"),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.black,
                  onPressed: () {
                    if (_loginFormKey.currentState.validate()) {
                      FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: emailInputController.text,
                        password: pwdInputController.text)
                        .catchError((err) => showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Error"),
                              content: Text("Incorrect email address or password"),
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
                        .then((currentUser) => Firestore.instance.collection("users")
                        .document(currentUser.uid).get()
                        .then((DocumentSnapshot result) => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Home(uid: currentUser.uid,)
                            )
                          )
                        ).catchError((err) => print(err))
                      ).catchError((err) => print(err));
                    }
                  },
                ),
                Text("Don't have an account?"),
                FlatButton(
                  child: Text("Register"),
                  onPressed: () {
                    Navigator.pushNamed(context, "/register");
                  },
                )
              ],
            ),
        ))));
  }
}