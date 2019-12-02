import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:twistter/auth_service.dart';
import 'package:twistter/profile.dart';
import 'package:twistter/post.dart';

void like(post, userID) async {
  if (post.likes.contains(userID)) {
    post.likes.remove(userID);
    Firestore.instance
        .collection('posts')
        .document(post.postID)
        .updateData({"likes": post.likes});

    Map<String, dynamic> updateData = {};
    String postUser = post.uid;
    post.topics.forEach((topic) =>
        updateData["followingUserTopicList.$postUser.Following.$topic"] =
            FieldValue.increment(-1));
    Firestore.instance
        .collection('users')
        .document(userID)
        .updateData(updateData);
  } else {
    post.likes.add(userID);
    Firestore.instance
        .collection('posts')
        .document(post.postID)
        .updateData({"likes": post.likes});

    Map<String, dynamic> updateData = {};
    String postUser = post.uid;
    post.topics.forEach((topic) =>
        updateData["followingUserTopicList.$postUser.Following.$topic"] =
            FieldValue.increment(1));
    Firestore.instance
        .collection('users')
        .document(userID)
        .updateData(updateData);
  }
}
