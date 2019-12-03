import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twistter/auth_service.dart';
import 'post.dart';
import 'home.dart';


class RePost extends StatefulWidget {
  // Declare a field that holds the Post.
  final Post post;
  // In the constructor, require a Post.
  RePost({Key key, @required this.post}) : super(key: key);

   @override
  _NewRepost createState() => _NewRepost(post: post);

  // @override
  // Widget build(BuildContext context) {
    
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text("Retwist"),
  //     ),
  //     body: Padding(
  //       padding: EdgeInsets.all(16.0),
  //       child: Text(post.content),
  //     ),
  //   );
  // }
}

class _NewRepost extends State<RePost> {
 final Post post;
 _NewRepost({ @required this.post});

  String uid;
  String firstName;
  String lastName;
  String username;
  String oldContent;
  String newContent;
  int remainingLength; 
 // Post newPost; 
 List<String> topics;

  TextEditingController postEditingController = new TextEditingController();


  initState() {
    super.initState();
    getUser();
  }

  void getUser() {
    uid = AuthService.currentUser.uid;
    firstName = AuthService.currentUser.firstName;
    lastName = AuthService.currentUser.lastName;
    username = AuthService.currentUser.username;
    topics = ["RT"];
    oldContent = post.content.trim();
    newContent = "\"@" + post.username + ": " + oldContent + "\"";
    remainingLength = 307 - newContent.length;
    if(remainingLength < 0) {
      remainingLength = 25; 
    }
   // topics = List.from(AuthService.currentUser.topicsList);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Repost"),
        actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add_comment),
              onPressed: () async {
                Firestore.instance
                      .collection('posts')
                      .add({
                        'content': newContent + " " + postEditingController.text,
                        'likes': [""],
                        'quotes': 0,
                        'timestamp': new DateTime.now().millisecondsSinceEpoch,
                        'topics': topics,
                        'uid': uid,
                        'username': username,
                        'firstName': firstName,
                        'lastName': lastName,
                      })
                      .then((value) {
                        Firestore.instance
                            .collection('users')
                            .document(uid)
                            .updateData({
                          'postsList':
                              FieldValue.arrayUnion([value.documentID]),
                        });
                        Firestore.instance
                            .collection('posts')
                            .document(value.documentID)
                            .updateData({"postID": value.documentID});
                      })
                      .then((result) => {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Home(
                                          uid: uid,
                                        )),
                                (_) => false),
                            postEditingController.clear()
                          })
                      .catchError((err) => print(err))
                      .catchError((err) => print(err));
              },
            )
          ],
      ),
      body: Container(
          padding: const EdgeInsets.all(20.0),
          child: new Theme(
            data: ThemeData(
                brightness: Brightness.light,
                backgroundColor: Color.fromRGBO(85, 176, 189, 1.0),
            ),
            child: SingleChildScrollView(
              child: Form(
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment(-1,-1),
                      child: new Text(
                        "\"@" + post.username + ": " + oldContent + "\"" ,
                        textAlign: TextAlign.left,
                        ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Create Repost',
                        hintText: "Add your comment here!",
                      ),
                      
                      maxLines: 7,
                      autofocus: true,
                      showCursor: true,
                      autocorrect: false,
                      textAlign: TextAlign.left,
                      keyboardAppearance: Brightness.dark,
                      controller: postEditingController,
                      maxLength: remainingLength,
                    ),

                  ],
                ),
              )
            )
          )
      )
    );
    
  }
}

//Get Current User

//Create Field to Enter Comment

//Create New Post

//Add Post to Database