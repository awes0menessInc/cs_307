import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:twistter/user.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static User currentUser;

  Future<FirebaseUser> getUser() {
    return _auth.currentUser();
  }

  static User getUserInfo() {
    return currentUser;
  }

  static void updateUser(firstName, lastName, email, bio, birthday, website, topics) {
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
      var result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser current = await _auth.currentUser();
      Firestore.instance.collection("users").document(current.uid).get().then((document) => {
        currentUser = new User(
          uid: document['uid'],
          username: document['username'],
          firstName: document['firstName'],
          lastName: document['lastName'],
          email: document['email'],
          bio: document['bio'],
          birthday: document['birthday'],
          website: document['website'],

          following: List<String>.from(document['followingList']),

          // numFollowers: .length,
          // numFollowing: document['following'],
        )
      });
      notifyListeners();
      return result;
    }  catch (e) {
      throw new AuthException(e.code, e.message);
    }
  }
}