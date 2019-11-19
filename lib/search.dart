import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twistter/auth_service.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  FirebaseUser currentUser;
  List _userResult = new List();
  List _topicResult = new List();
  List _blogResult = new List();
  String _oldQuery = "";

  TextEditingController searchInputController = new TextEditingController();
  final GlobalKey<FormState> _searchFormKey = GlobalKey<FormState>();

  @override
  initState() {
   
    super.initState();
    getUser();
  }

  void getUser() {
    FirebaseAuth.instance.currentUser().then((currentUser) => {
      if (currentUser == null) {
        Navigator.pushReplacementNamed(context, '/login')
      } else {
        this.currentUser = currentUser
      }
    });
  }

  void searchUsers(String query) {
    Firestore.instance.collection("users").getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((doc) => {
        if (doc["topics"] != null) {
          for (int i = 0; i < doc["topics"].length; i++) {
            if (doc["topics"][i].toString().toLowerCase().contains(query)) {
              _userResult.add(doc["username"])
            }
            // TODO: populate list with users and aggregate later with topics and blogs(maybe)
            // create user, topic, and blog objects
          }
        }
      });
    });
    // return ListView.builder(
    //   itemCount: _userResult.length,
    //   itemBuilder: (BuildContext context, int index) {
    //     return new Text(_userResult[index]);
    //   },
    // );
  }

  void search(String query) {
    searchUsers(query);
  }

  void fieldChanged(String str) {
    if (str.length >= 2) {
      searchUsers(str);
    }
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: TextFormField(
        decoration: InputDecoration(hintText: 'Search'),
        controller: searchInputController,
        keyboardType: TextInputType.text,
        autofocus: true,
        onChanged: fieldChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: Container(
        child: Text("temp")
      ),
    );
  }
}
