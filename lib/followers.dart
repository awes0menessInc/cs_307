import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twistter/auth_service.dart';
import 'package:twistter/otherUserProfile.dart';
import 'package:twistter/user.dart';
import 'package:twistter/metrics.dart';

class Followers extends StatefulWidget {
  @override
  _FollowersState createState() => _FollowersState();
}

class _FollowersState extends State<Followers> {
  List<User> _results = new List();

  @override
  initState() {
    super.initState();
    getFollowers();
  }

  void getFollowers() async {
    await Firestore.instance
        .collection("users")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((doc) {
        if (AuthService.currentUser.followersList.contains(doc['uid']) &&
            doc['uid'] != AuthService.currentUser.uid) {
          _results.add(new User(
            uid: doc['uid'],
            username: doc['username'],
            firstName: doc['firstName'],
            lastName: doc['lastName'],
            email: doc['email'],
            bio: doc['bio'],
            website: doc['website'],
          ));
        }
      });
    });
    setState(() {
      _results = sortFollowers(_results);
    });
  }

  Widget buildResults() {
    return ListView.builder(
      itemCount: _results.length,
      itemBuilder: (context, index) {
        return buildCard(context, _results[index]);
      },
    );
  }

  Widget buildCard(BuildContext context, User user) {
    return Card(
        elevation: 8,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              child: buildListTile(context, user),
            ),
          ],
        ));
  }

  Widget buildListTile(BuildContext context, User user) {
    return ListTile(
      onTap: () {
        print("tap!");
        var route = new MaterialPageRoute(
          builder: (BuildContext context) =>
              new OtherUserProfilePage(userPage: user.uid),
        );
        Navigator.of(context).push(route);
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
          padding: EdgeInsets.only(right: 5.0),
          child: Icon(
            Icons.account_circle,
            size: 45.0,
            color: Color.fromRGBO(5, 62, 66, 1.0),
          )),
      title: Container(
          padding: EdgeInsets.all(0),
          child: InkWell(
              child: Text(
            user.firstName + " " + user.lastName,
            style: TextStyle(
              color: Color.fromRGBO(7, 113, 136, 1.0),
              fontWeight: FontWeight.bold,
              fontSize: 12,
              fontFamily: 'Poppins',
            ),
          ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Followers")),
      body: Container(child: buildResults()),
    );
  }
}
