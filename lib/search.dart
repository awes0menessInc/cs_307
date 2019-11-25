import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twistter/profile.dart';
import 'package:twistter/user.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  FirebaseUser currentUser;
  List<User> _results = new List();

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

  bool shouldAdd(DocumentSnapshot doc, String query) {
    if (doc["topics"]!= null) {
      if (doc["topics"] != 0) {
        for (int i = 0; i < doc["topics"].length; i++) {
          if (doc["topics"][i].toString().toLowerCase().contains(query)) {
            if (!_results.contains(doc["username"]) && doc["username"] != null) {
              return true;
            }             
          }
        }
      }
    }
    
    if (doc["username"].toString().toLowerCase().contains(query)) {
      return true;
    }

    if (doc["firstName"].toString().toLowerCase().contains(query)) {
      return true;
    }

    if (doc["lastName"].toString().toLowerCase().contains(query)) {
      return true;
    }
    
    return false;
  }

  void searchUsers(String query) async{
    _results.clear();
    await Firestore.instance.collection("users").getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((doc) => {
        print(doc["firstName"] + " " + doc["lastName"] + ", add: " + shouldAdd(doc, query).toString()),
        if (shouldAdd(doc, query)) {
          _results.add(new User(
            uid: doc['uid'],
            username: doc['username'],
            firstName: doc['firstName'],
            lastName: doc['lastName'],
            email: doc['email'],
            bio: doc['bio'],
            birthday: doc['birthday'],
            website: doc['website'],
          ))
        }
      });
    });
  }

  void fieldChanged(String str) {
    _results.clear();
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
      actions: <Widget>[
        IconButton (
          icon: Icon(Icons.search),
          onPressed: () {
            
              FocusScope.of(context).requestFocus(FocusNode());
            
          },
        )
      ],
    );
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
      )
    );
  }
  
  Widget buildListTile(BuildContext context, User user) {
    return ListTile(
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
            onTap: () {
              print("tap!");
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) =>
                      new ProfilePage(userPage: user.uid),
                );
                Navigator.of(context).push(route);
            },
            child: Text(
              user.firstName + " " + user.lastName,
              style: TextStyle(
                color: Color.fromRGBO(7, 113, 136, 1.0),
                fontWeight: FontWeight.bold,
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
            )
          )
        ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: Container(
        child: buildResults()
      ),
    );
  }
}
