import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twistter/auth_service.dart';
import 'package:twistter/otherUserProfile.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:twistter/profile.dart';
import 'package:twistter/post.dart';
import 'package:twistter/repost.dart';
import 'package:twistter/metrics.dart';

class Timeline extends StatefulWidget {
  Timeline({Key title}) : super(key: title);

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(primaryColor: Color(0xff053E42)),
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
  List<String> topics;

  TextEditingController controller = new TextEditingController();
  FocusNode _focusNode;
  String filter;

  Color _iconColor = Color.fromRGBO(5, 62, 66, 1.0);
  //R: 214 G: 59 B: 47
  Color _iconColorPressed = Color.fromRGBO(214, 59, 47, 1.0);
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

  List<String> selectedTopics = List();
  List<Widget> _buildChoiceList(Post post, BuildContext context) {
    topics = List.from(post.topics);
    print(topics);
    topics.removeWhere((item) =>
        item ==
        ""); //removes any empty strings from the topic list before displaying
    if (topics.length == 0) {
      return null;
    }
    List<Widget> choices = List();
    topics.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: Chip(
          // child: ChoiceChip (
          label: Text(item, style: TextStyle(color: Colors.black)),
          // disabledColor: Color(0xff999999),
          // backgroundColor: Color(0xff55b0bd),
          // selected: selectedTopics.contains(item),
          // selected: true,
          // onSelected: (selected) {
          //   setState(() {
          //     selectedTopics.contains(item)
          //         ? selectedTopics.remove(item)
          //         : selectedTopics.add(item);
          //   });
          // },
        ),
      ));
    });
    return choices;
  }

  void showTags(BuildContext context, Post post) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Post Tags"),
          content: Wrap(
            children: _buildChoiceList(post, context),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<Post> getPosts(List<DocumentSnapshot> snap) {
    List<Post> postsList = [];
    snap.forEach((f) {
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
                score: 0,
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
      posts = posts.where((post) {
        bool flag = false;
        for (String topic in post.topics) {
          // better filter using substring.
          flag = flag || topic.toLowerCase().contains(filter.toLowerCase());
        }
        return flag;
      }).toList();
    }

    posts = sortPosts(posts);

    return Container(
        child: new ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (content, index) => _makeCard(context, posts[index], index),
      itemCount: posts.length,
    ));
  }

  _pageNavigation(uid) {
    if (uid == AuthService.currentUser.uid) {
      return new ProfilePage(userPage: uid);
    } else {
      return new OtherUserProfilePage(userPage: uid);
    }
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
                  builder: (BuildContext context) => _pageNavigation(post.uid),
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
      // subtitle: Text(
      //   //_blogtext,
      //   post.content,
      //   style: TextStyle(fontSize: 11),
      // ),
      subtitle: ParsedText(
        text: post.content,
        style: TextStyle(
          fontSize: 12,
          color: Colors.black,
        ),
        parse: <MatchText>[
          MatchText(
            pattern: r"([@#][\w_-]+:)",
            style: TextStyle(
              color: Color.fromRGBO(7, 113, 136, 1.0),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            onTap: (url) {},
          ),
        ],
      ),
      // trailing: Text(timeago
      //     .format(new DateTime.fromMillisecondsSinceEpoch(post.timestamp))
      //   ),
      trailing: Text(
          timeago
              .format(new DateTime.fromMillisecondsSinceEpoch(post.timestamp)),
          style: TextStyle(fontSize: 11)),
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
                height: 60,
                child: ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: Text("View Tags",
                          style: TextStyle(
                            fontSize: 11,
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
                        width: 30,
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
                )),
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
                }, //TODO: match styling to other search bar
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
                    if (snapshot.hasError)
                      return new Text('Error in timeline StreamBuilder');
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
