import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twistter/user.dart';
import 'package:twistter/profile.dart';
import 'post.dart';
import 'repost.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RePost extends StatelessWidget {
  // Declare a field that holds the Post.
  final Post post;
 // final User current_user; 

  // In the constructor, require a Post.
  RePost({Key key, @required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Retwist"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(post.content),
      ),
    );
  }
}


//Get Current User

//Create Field to Enter Comment

//Create New Post

//Add Post to Database