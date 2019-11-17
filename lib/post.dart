import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Post {
  //final String id;
  final String username;
  final String fullName;
  final String content;
  final List<String> topics;
  final String uid;
  //final String topics;

  const Post({this.username, this.fullName, this.content, this.topics, this.uid});

}


class PostList{
  List<Post> postList;
  PostList({this.postList});

}