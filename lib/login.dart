import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:twistter/auth_service.dart';
import 'package:twistter/home.dart';


class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  bool loading;

  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    loading = false;
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value.trim())) {
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

  Future buildErrorDialog(BuildContext context, message) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                // loading = false;
                setState(() {
                  loading = !loading;
                });
                pwdInputController.clear();
                Navigator.of(context).pop();
              }
            )
          ],
        );
      },
    );
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
                      fontSize: 12,
                    )
                  ),
                  onPressed: (){
                     FirebaseAuth.instance.sendPasswordResetEmail(email: emailInputController.text).then((currentUser) => showDialog(context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Email Sent!"),
                              content: Text("Please reset your password using the link sent to your account email."),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("Close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          })).catchError((err) => showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Error"),
                              content: Text("Incorrect email address"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("Close"),
                                  onPressed: () {
                                    emailInputController.clear();
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          }));
                  }
                ),
                RaisedButton(
                  child: Text("Login"),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.black,
                  onPressed: () async {
                    if (_loginFormKey.currentState.validate()) {
                      setState(() {
                        loading = !loading;
                      });
                      try {
                        FirebaseUser result = 
                        await Provider.of<AuthService>(context).loginUser(
                                  email: emailInputController.text,
                                  password: pwdInputController.text);
                          print(result);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Home())
                          );
                        } on AuthException catch (error) {
                          return buildErrorDialog(context, "Incorrect email address or password");
                        } on Exception catch (error) {
                          return buildErrorDialog(context, error.toString());
                        }
                    }

                    // if (_loginFormKey.currentState.validate()) {
                    //   FirebaseAuth.instance.signInWithEmailAndPassword(
                    //     email: emailInputController.text,
                    //     password: pwdInputController.text)
                    //     .catchError((err) => showDialog(
                    //       context: context,
                    //       builder: (BuildContext context) {
                    //         return AlertDialog(
                    //           title: Text("Error"),
                    //           content: Text("Incorrect email address or password"),
                    //           actions: <Widget>[
                    //             FlatButton(
                    //               child: Text("Close"),
                    //               onPressed: () {
                    //                 loading = false;
                    //                 pwdInputController.clear();
                    //                 Navigator.of(context).pop();
                    //               },
                    //             )
                    //           ],
                    //         );
                    //       }))
                    //     .then((currentUser) => Firestore.instance.collection("users")
                    //     .document(currentUser.uid).get()
                    //     .then((DocumentSnapshot result) => Navigator.pushReplacement(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => Home(uid: currentUser.uid,)
                    //         )
                    //       )
                    //     ).catchError((err) => print(err))
                    //   ).catchError((err) => print(err));
                    // }
                    // print('running cui.getUserInfo...');
                    // // cui.getUserInfo();
                    // print('ran cui.getUserInfo. ');
                  },
                ),
                Text("Don't have an account?"),
                RaisedButton(
                  child: Text("Register"),
                  onPressed: () {
                    Navigator.pushNamed(context, "/register");
                  },
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: loading ? LinearProgressIndicator() : Container(height:0)
                )
              ],
            ),
        ))));
  }
}