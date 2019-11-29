import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:twistter/home.dart';

class Splash extends StatefulWidget {
  Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((currentUser) => {
      if (currentUser == null) {
        Navigator.pushReplacementNamed(context, '/login')
      }
      else {
        Firestore.instance.collection('users').document(currentUser.uid).get()
        .then((DocumentSnapshot snapshot) => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home(uid: currentUser.uid,)
          )
        )).catchError((err) => print(err))
      }
    }).catchError((err) => print(err));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingCircle();
  }
}

class LoadingCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.white,
        child: CircularProgressIndicator(),
        alignment: Alignment(0.0, 0.0),
      ),
    );
  }
}