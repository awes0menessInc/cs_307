import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  FirebaseUser currentUser;

  TextEditingController searchInputController = new TextEditingController();
  final GlobalKey<FormState> _searchFormKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
  }

  Widget buildUserResult() {

  }

  Widget buildTopicResult() {

  }

  Widget buildBlogResult() {
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Form(
          key: _searchFormKey,
          child: TextFormField(
            decoration: InputDecoration(hintText: 'Search'),
            controller: searchInputController,
            keyboardType: TextInputType.text,
            autofocus: true,
          ),
        ),
      ),
    );
  }

  

}
