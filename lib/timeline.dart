import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:twistter/auth_service.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:twistter/profile.dart';
import 'package:twistter/post.dart';
import 'package:twistter/repost.dart';
import 'package:twistter/metrics.dart';

class Timeline extends StatefulWidget {
  Timeline({Key title}) : super(key: title);

  @override
  _TimelineState createState() => _TimelineState();

  // @override
  // Widget build(BuildContext context) {
  //   return new MaterialApp(
  //     theme: new ThemeData(primaryColor: Colors.white),
  //     home: new ListPage(title: 'Timeline'),
  //     debugShowCheckedModeBanner: false,
  //   );
  // }
}

class _TimelineState extends State<Timeline> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(primaryColor: Colors.white),
      home: new ListPage(
        title: 'Timeline',
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ListPage extends StatefulWidget {
  ListPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  static const String KEY_LAST_FETCH = "last_fetch";
  static const int MILLISECONDS_IN_HOUR = 3600000;
  static const int REFRESH_THRESHOLD = 3 * MILLISECONDS_IN_HOUR;

  List<Post> posts = [];
  List<String> following;
  Map<String, dynamic> followingUserTopic;

  TextEditingController controller = new TextEditingController();
  FocusNode _focusNode;
  String filter;

  Color _iconColor = Color.fromRGBO(5, 62, 66, 1.0);
  Color _iconColorPressed = Colors.red;
  Icon _icon = Icon(Icons.favorite_border, size: 20);
  Icon _iconPressed = Icon(Icons.favorite, size: 20);

  initState() {
    getUser();
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
    super.initState();
    _focusNode = FocusNode();
  }

  dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  Future getUser() async {
    await FirebaseAuth.instance.currentUser().then((currentuser) => {
          Firestore.instance
              .collection("users")
              .document(currentuser.uid)
              .get()
              .then((DocumentSnapshot snapshot) => {
                    setState(() {
                      following = List.from(snapshot["followingList"]);
                      followingUserTopic = Map<String, dynamic>.from(
                          snapshot["followingUserTopicList"]);
                    })
                  })
        });
  }

  void showTags(BuildContext context, Post post) {
    AlertDialog viewTags = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      title: Text('Post Tags',
          textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Poppins')),
      content: Container(
        height: 50,
        child: ListView(
            padding: EdgeInsets.all(4),
            children: post.topics
                .map((data) => Padding(
                    padding: EdgeInsets.all(4),
                    child: Text(
                      data = "#" + data,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                      ),
                    )))
                .toList()),
      ),
      actions: <Widget>[
        Container(
          padding: EdgeInsets.only(right: 75),
          child:
              ButtonBar(alignment: MainAxisAlignment.center, children: <Widget>[
            SizedBox(
              width: 100,
              child: new RaisedButton(
                color: Color.fromRGBO(85, 176, 189, 1.0),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                },
                child: Text('Close', style: TextStyle(color: Colors.white)),
              ),
            ),
          ]),
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return viewTags;
      },
    );
  }

  List<Post> getPosts(List<DocumentSnapshot> snap) {
    List<Post> postsList = [];
    List<dynamic> tags = [];
    snap.forEach((f) {
      //   if (following.contains(f["uid"])) {
      //     postsList.add(Post(
      //         content: f['content'],
      //         username: f['username'],
      //         fullName:
      //             f['firstName'].toString() + " " + f['lastName'].toString(),
      //         topics: List.from(f['topics']),
      //         uid: f['uid']));
      //   }
      // });
      if (followingUserTopic != null &&
          followingUserTopic.containsKey(f["uid"])) {
        List<dynamic> topicList;
        for (var entry in followingUserTopic.entries) {
          if (entry.key == f["uid"]) {
            Map<dynamic, dynamic> temp = entry.value;
            Map<dynamic, dynamic> temp2 = temp["NotFollowing"];
            topicList = temp2.keys.toList();
            break;
          }
        }
        List<String> topic = topicList.cast<String>().toList();
        List<String> docTopic = List.from(f['topics']);
        for (String top in docTopic) {
          if (topic.contains(top)) {
            break;
          } else {
            postsList.add(Post(
                content: f['content'],
                username: f['username'],
                fullName:
                    f['firstName'].toString() + " " + f['lastName'].toString(),
                topics: List.from(f['topics']),
                timestamp: f['timestamp'],
                likes: List.from(f['likes']),
                postID: f['postID'],
                uid: f['uid']));
            break;
          }
        }
      }
    });
    return postsList;
  }

  Widget _makeBody(BuildContext context, List<DocumentSnapshot> snap) {
    posts = getPosts(snap);
    if (filter == null || filter == "") {
    } else {
      posts = posts.where((post) => post.topics.contains(filter)).toList();
    }
    return Container(
        child: new ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (content, index) => _makeCard(context, posts[index], index),
      itemCount: posts.length,
    ));
  }

  Widget _makeListTile(BuildContext context, Post post) {
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
                      new ProfilePage(userPage: post.uid),
                );
                Navigator.of(context).push(route);
              },
              child: Text(
                post.fullName,
                style: TextStyle(
                  color: Color.fromRGBO(7, 113, 136, 1.0),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  fontFamily: 'Poppins',
                ),
              ))),
      subtitle: Text(
        //_blogtext,
        post.content,
        style: TextStyle(fontSize: 11),
      ),
      trailing: Text(timeago
          .format(new DateTime.fromMillisecondsSinceEpoch(post.timestamp))),
    );
  }

  Widget _makeCard(BuildContext context, Post post, int index) {
    return Card(
        elevation: 8,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              child: _makeListTile(context, post),
            ),
            //ButtonBar
            SizedBox(
                height: 50,
                child: ButtonTheme.bar(
                    //padding: EdgeInsets.only(top: 0),
                    child: ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: Text("View Tags",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromRGBO(5, 62, 66, 1.0),
                          )),
                      onPressed: () => showTags(context, post),
                    ),
                    SizedBox(
                        width: 25,
                        child: IconButton(
                            icon: Icon(Icons.add_comment, size: 19),
                            color: Color.fromRGBO(5, 62, 66, 1.0),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RePost(post: posts[index])),
                              );
                            })),
                    SizedBox(
                        width: 40,
                        child: IconButton(
                          icon: post.likes.contains(AuthService.currentUser.uid)
                              ? _iconPressed
                              : _icon,
                          color:
                              post.likes.contains(AuthService.currentUser.uid)
                                  ? _iconColorPressed
                                  : _iconColor,
                          onPressed: () {
                            setState(() {
                              like(post, AuthService.currentUser.uid);
                            });
                          },
                        )),
                  ],
                ))),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    //Firestore.instance
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        // backgroundColor: Color.fromRGBO(85, 176, 189, 1.0),
        body: Stack(
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.only(top: 20.0),
            ),
            new Container(
              padding: new EdgeInsets.symmetric(horizontal: 10),
              child: new TextField(
                focusNode: _focusNode,
                autofocus: false,
                textInputAction: TextInputAction.done,
                decoration: new InputDecoration(labelText: "Filter by Topics"),
                onEditingComplete: () {
                  _focusNode.unfocus();
                },
                controller: controller,
              ),
            ),
            new Container(
              padding: new EdgeInsets.only(top: 40),
              child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection('posts')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) return new Text('Error');
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Container(
                            alignment: Alignment.bottomCenter,
                            child: LinearProgressIndicator());
                      default:
                        return _makeBody(context, snapshot.data.documents);
                    } //switch
                  } //asyncsnapshot
                  ),
            )
          ],
        ));
  }
}
