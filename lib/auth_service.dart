import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:twistter/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;
  static User currentUser;

  // Future<FirebaseUser> getUser() {
  //   return _auth.currentUser();
  // }

  @override
  initState() {
    _getUID().then((uid) => initUser(uid));
  }

  static Future<String> _getUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get("user");
  }

  static User getUserInfo() {
    return currentUser;
  }

  static void initUser(String uid) {
    if (uid == null || uid == "") {
      _getUID().then((x) => uid = x);
    }

    Firestore.instance
        .collection("users")
        .document(uid)
        .get()
        .then((document) => {
              currentUser = User(
                  uid: document['uid'],
                  username: document['username'],
                  firstName: document['firstName'],
                  lastName: document['lastName'],
                  email: document['email'],
                  bio: document['bio'],
                  birthday: document['birthday'].toDate(),
                  website: document['website'],
                  followers: document['followers'],
                  following: document['following'],
                  posts: document['posts'],
                  topics: document['topics'],
                  followersList: List<String>.from(document['followersList']),
                  followingList: List<String>.from(document['followingList']),
                  postsList: List<String>.from(document['postsList']),
                  topicsList: List<String>.from(document['topicsList']),
                  followingUserTopicList: Map<String, dynamic>.from(
                      document['followingUserTopicList']))
            });
  }

  static void updateUser(
      firstName, lastName, email, bio, birthday, website, topics) {
    currentUser.firstName = firstName;
    currentUser.lastName = lastName;
    currentUser.email = email;
    currentUser.bio = bio;
    currentUser.birthday = birthday;
    currentUser.website = website;
    currentUser.topics = topics;
  }

  Future logout() async {
    var result = FirebaseAuth.instance.signOut();
    currentUser = null;
    notifyListeners();
    return result;
  }

  Future<FirebaseUser> loginUser({String email, String password}) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      firebaseUser = await _auth.currentUser();
      initUser(firebaseUser.uid);
      notifyListeners();
      return result;
    } catch (e) {
      throw new AuthException(e.code, e.message);
    }
  }

  Future<FirebaseUser> registerUser(
      {String email,
      String password,
      String username,
      String firstName,
      String lastName,
      DateTime birthday}) async {
    try {
      var result =
          _auth.createUserWithEmailAndPassword(email: email, password: email);
      firebaseUser = await _auth.currentUser();
      initUser(firebaseUser.uid);
      notifyListeners();
      return result;
    } catch (e) {
      throw new AuthException(e.code, e.message);
    }
  }
}
