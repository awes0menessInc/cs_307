import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:twistter/auth_service.dart';
import 'package:twistter/post.dart';
import 'package:twistter/profile.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';

class OtherUserProfilePage extends StatefulWidget {
  String userPage;
  OtherUserProfilePage({Key key, this.userPage}) : super(key: key);

  @override
  OtherUserProfilePageState createState() =>
      OtherUserProfilePageState(userPage);
}

class OtherUserProfilePageState extends State<OtherUserProfilePage> {
  String uid = "";
  String firstName = "N";
  String username = "";
  String lastName = "A";
  String email;
  String bio = "";
  String userPage;
  // List<String> _topics;

  int followers;
  int following;
  int _posts;
  int _topics;

  // List<String> postsList;
  List<Post> posts = [];
  List<String> _topicsList = [];
  List<String> followersList = [];
  List<String> topicsSelected = [];

  static bool pressed = false;
  bool isAccountOwner = false; // TODO: Connect to a function on the back end

  File _image;

  OtherUserProfilePageState(this.userPage);

  @override
  initState() {
    getUserInfo();
    super.initState();
  }

  void getUserInfo() async {
    var userQuery = Firestore.instance
        .collection('users')
        .where('uid', isEqualTo: userPage)
        .limit(1);
    userQuery.getDocuments().then((data) {
      if (data.documents.length > 0) {
        setState(() {
          uid = data.documents[0].data['uid'];
          firstName = data.documents[0].data['firstName'];
          lastName = data.documents[0].data['lastName'];
          username = data.documents[0].data['username'];
          bio = data.documents[0].data['bio'];
          List<String> postsList =
              List<String>.from(data.documents[0].data['postsList']);
          List<String> topList =
              List<String>.from(data.documents[0].data['topicsList']);
          _posts = postsList.length;
          _topics = topList.length;
          followersList =
              List<String>.from(data.documents[0].data['followersList']);
          List<String> followList =
              List<String>.from(data.documents[0].data['followingList']);
          _topicsList = List<String>.from(data.documents[0].data['topicsList']);
          followers = followersList.length;
          following = followList.length - 1;
          Map<String, dynamic> completeList =
              AuthService.currentUser.followingUserTopicList;
          if (completeList.containsKey(uid)) {
            Map<String, dynamic> fol = completeList[uid];
            Map<String, dynamic> f = fol["Following"];
            topicsSelected = List<String>.from(f.keys);
          } else {
            topicsSelected = [];
          }
        });
      }
    });
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);

    setState(() {
      _image = image;
      print('Image Path $_image');
    });
  }

  Future uploadPic() async {
    print("Uploading...");
    String fileName = basename('$uid.jpg');
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    print("File Uploaded");
  }

  Widget _buildProfileImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.only(left: 47),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 75,
              child: ClipOval(
                child: new SizedBox(
                  width: 140.0,
                  height: 140.0,
                  child: (_image != null)
                      ? Image.file(
                          _image,
                          fit: BoxFit.fill,
                        )
                      : Container(
                          decoration: new BoxDecoration(
                            color: Color(0xff55b0bd),
                            borderRadius: BorderRadius.circular(80.0),
                          ),
                          child: Center(
                            child: Text('${firstName[0]}' + '${lastName[0]}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 50.0)),
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 80.0),
          child: IconButton(
            icon: Icon(
              Icons.photo_camera,
              size: 30.0,
            ),
            onPressed: () {
              getImage();
              uploadPic();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFullName(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Text(
          '$firstName $lastName | @' + username,
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
          ),
        ));
  }

  List<String> selectedTopics = List();
  List<String> notSelectedTopics = List();
  List<Widget> _buildChoiceList(List<String> topic) {
    if (topic != null && topic.length != 0) {
      // topic.removeWhere((item) =>
      //     item == "" ||
      //     item ==
      //         "RT"); //removes any empty strings from the topic list before displaying
      if (topic.length == 0) {
        return null;
      }
      // topic.removeWhere((item) => item == "RT");
      List<Widget> choices = List();

      topic.forEach((item) {
        choices.add(Container(
          padding: const EdgeInsets.all(2.0),
          child: ChoiceChip(
            label: Text(
              item,
              style: TextStyle(color: Colors.black),
            ),
            selectedShadowColor: Color(0xff55B0BD),
            selectedColor: Color(0xff55B0BD),
            selected: topicsSelected.contains(item),
            onSelected: (selected) {
              setState(() {
                if (selectedTopics.contains(item)) {
                  selectedTopics.remove(item);
                  notSelectedTopics.add(item);
                } else {
                  notSelectedTopics.remove(item);
                  selectedTopics.add(item);
                }
                //     ? selectedTopics.remove(item)
                //     : selectedTopics.add(item);
                // notSelectedTopics.contains(item)
                //     ? notSelectedTopics.remove(item)
                //     : notSelectedTopics.add(item);
              });
            },
          ),
        ));
      });
      Map<String, dynamic> followingUserTopicsList =
          AuthService.currentUser.followingUserTopicList;
      if (followingUserTopicsList.containsKey(uid)) {
        Map<String, dynamic> follow = followingUserTopicsList[uid];
        Map<String, int> followingTopics = follow["Following"];
        Map<String, int> notFollowingTopics = follow["NotFollowing"];
        for (String item in selectedTopics) {
          followingTopics[item] = 0;
          notFollowingTopics.remove(item);
        }
        topicsSelected = List<String>.from(followingTopics.keys);
        for (String item in notSelectedTopics) {
          notFollowingTopics[item] = 0;
          followingTopics.remove(item);
        }
        Map<String, dynamic> notFollowingUserTopicsList = {
          "Following": followingTopics,
          "NotFollowing": notFollowingTopics
        };
        Map<String, dynamic> temp = {
          uid: Map<String, dynamic>.from(notFollowingUserTopicsList)
        };
        followingUserTopicsList.addAll(temp);
        Firestore.instance
            .collection("users")
            .document(AuthService.currentUser.uid)
            .updateData({
          "followingUserTopicList":
              Map<String, dynamic>.from(followingUserTopicsList)
        });
      }
      return choices;
    } else {
      return null;
    }
  }

  Widget _buildStatItem(String label, String count) {
    TextStyle _statLabelTextStyle = TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.black,
      fontSize: 12.0,
      fontWeight: FontWeight.w200,
    );

    TextStyle _statCountTextStyle = TextStyle(
      color: Colors.black54,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count,
          style: _statCountTextStyle,
        ),
        Text(
          label,
          style: _statLabelTextStyle,
        ),
      ],
    );
  }

  String formatStat(int stat) {
    String newStat;
    if ((stat >= 1000) && (stat < 1000000)) {
      newStat = (stat / 1000).toStringAsFixed(1) + "K";
    } else if (stat >= 1000000) {
      newStat = (stat / 1000000).toStringAsFixed(1) + "M";
    } else {
      newStat = stat.toString();
    }
    return newStat;
  }

  Widget _buildStatContainer(context) {
    return Container(
      height: 60.0,
      margin: EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        color: Color(0xFFEFF4F7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          InkWell(
            child: _buildStatItem("Followers", followers.toString()),
            onTap: () {
              Navigator.pushNamed(context, "/followers");
            },
          ),
          InkWell(
            child: _buildStatItem("Following", following.toString()),
            onTap: () {
              Navigator.pushNamed(context, "/following");
            },
          ),
          _buildStatItem("Posts", _posts.toString()),
          // _buildStatItem("Topics", _topics.toString()),
        ],
      ),
    );
  }

  // Widget _buildDemoButton() {
  //   return FlatButton(
  //       color: Colors.white,
  //       onPressed: () {
  //         setState(() {
  //           isAccountOwner = !isAccountOwner;
  //         });
  //       },
  //       child: Text('For Demo Purposes Only',
  //           style: TextStyle(color: Colors.red)));
  // }

  Widget _buildBio(BuildContext context) {
    TextStyle bioTextStyle = TextStyle(
      fontFamily: 'Spectral',
      fontWeight: FontWeight.w600,
      color: Colors.black,
      fontSize: 16.0,
    );
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.all(8.0),
      child: Text(
        bio,
        textAlign: TextAlign.center,
        style: bioTextStyle,
      ),
    );
  }

  Widget _buildSeparator(Size screenSize) {
    return Container(
      width: screenSize.width / 1.2,
      height: 2.0,
      color: Colors.black54,
      margin: EdgeInsets.only(top: 4.0),
    );
  }

  Color getColor(bool pressed) {
    if (pressed) {
      return Color(0xffd1d1d1);
    } else {
      return Color(0xff077188);
    }
  }

  Text getText(bool pressed) {
    if (pressed ||
        (followersList != null &&
            followersList.contains(AuthService.currentUser.uid))) {
      return Text('Following', style: TextStyle(color: Colors.black));
    } else {
      return Text('Follow', style: TextStyle(color: Colors.white));
    }
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              Visibility(
                  visible: !isAccountOwner,
                  child: Expanded(
                      child: RaisedButton(
                          color: getColor(pressed),
                          onPressed: () {
                            setState(() {
                              if (pressed &&
                                  followersList != null &&
                                  followersList
                                      .contains(AuthService.currentUser.uid)) {
                                if (followersList
                                    .contains(AuthService.currentUser.uid)) {
                                  followersList
                                      .remove(AuthService.currentUser.uid);
                                  Firestore.instance
                                      .collection("users")
                                      .document(uid)
                                      .updateData({
                                    "followersList": List.from(followersList)
                                  });
                                }
                                if (AuthService
                                    .currentUser.followingUserTopicList
                                    .containsKey(uid)) {
                                  Map<String, dynamic> temp = AuthService
                                      .currentUser.followingUserTopicList;
                                  temp.remove(uid);
                                  List<String> temp3 =
                                      AuthService.currentUser.followingList;
                                  temp3.remove(uid.toString());
                                  Firestore.instance
                                      .collection("users")
                                      .document(AuthService.currentUser.uid)
                                      .updateData({
                                    "followingUserTopicList":
                                        Map<String, dynamic>.from(temp),
                                    "followingList": List.from(temp3)
                                  });
                                }
                              } else {
                                followersList.add(AuthService.currentUser.uid);
                                Firestore.instance
                                    .collection("users")
                                    .document(uid)
                                    .updateData({
                                  "followersList": List.from(followersList)
                                });
                                Map<String, dynamic> followingUserTopicList =
                                    AuthService
                                        .currentUser.followingUserTopicList;
                                Map<String, int> topicLike = {};
                                for (String top in _topicsList) {
                                  topicLike[top] = 0;
                                }
                                Map<String, dynamic> followingTopic = {
                                  "Following": topicLike,
                                  "NotFollowing": {'a': 0}
                                };
                                Map<String, dynamic> addKey = {
                                  uid: Map<String, dynamic>.from(followingTopic)
                                };
                                Map<String, dynamic> temp = AuthService
                                    .currentUser.followingUserTopicList;
                                temp.addAll(addKey);
                                List<String> temp2 =
                                    AuthService.currentUser.followingList;
                                if (temp2.contains(uid)) {
                                  temp2 = temp2;
                                } else {
                                  temp2.add(uid.toString());
                                }
                                Firestore.instance
                                    .collection("users")
                                    .document(AuthService.currentUser.uid)
                                    .updateData({
                                  "followingUserTopicList":
                                      Map<String, dynamic>.from(temp),
                                  "followingList": List.from(temp2),
                                });
                              }
                              pressed = !pressed;
                            });
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          child: getText(pressed))))
            ]),
          ],
        ));
  }

  Text _noPostsText() {
    TextStyle ts = TextStyle(
      fontFamily: 'Spectral',
      fontWeight: FontWeight.w400,
      color: Color(0xFF799497),
      fontSize: 16.0,
    );

    if (isAccountOwner) {
      return Text(
          "You haven't posted yet. Click the new post button to create your first post!",
          textAlign: TextAlign.center,
          style: ts);
    } else {
      return Text("$firstName hasn't posted yet. Check back later!",
          textAlign: TextAlign.center, style: ts);
    }
  }

  Widget _buildNoPosts(BuildContext context) {
    return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: EdgeInsets.all(8.0),
        child: _noPostsText());
  }

  List<Post> getPosts(List<DocumentSnapshot> snap) {
    List<Post> posts = [];
    if (snap != null && snap.isNotEmpty) {
      snap.forEach((post) {
        posts.add(Post(
            content: post['content'],
            username: post['username'],
            fullName: post['firstName'].toString() +
                " " +
                post['lastName'].toString(),
            topics: List.from(post['topics']),
            uid: post['uid']));
      });
    }
    return posts;
  }

  Widget _makeListTile(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 5.0),
        child: Icon(Icons.account_circle,
            size: 45.0, color: Color.fromRGBO(5, 62, 66, 1.0)),
      ),
      title: Text(
        "BoilerMaker",
        style: TextStyle(
            color: Color.fromRGBO(7, 113, 136, 1.0),
            fontWeight: FontWeight.bold,
            fontSize: 12),
      ),
      subtitle: Text(
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
          style: TextStyle(fontSize: 11)),
      trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(Icons.favorite, size: 20.0),
            Icon(Icons.add_comment, size: 20.0)
          ]),
    );
  }

  Widget _makeBody(BuildContext context) {
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return _makeCard(context);
        },
      ),
    );
  }

  Widget makeBody(BuildContext context, List<DocumentSnapshot> snap) {
    posts = getPosts(snap);
    return Container(
        child: ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (content, index) => makeCard(context, posts[index]),
      itemCount: posts.length,
    ));
  }

  Widget _makeCard(BuildContext context) {
    return Card(
      elevation: 8.0,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: _makeListTile(context),
      ),
    );
  }

  Widget makeCard(BuildContext context, Post post) {
    return Card(
      elevation: 8.0,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: makeListTile(context, post),
      ),
    );
  }

  Widget buildUserline(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('posts')
                .orderBy('timestamp', descending: true)
                .where('uid', isEqualTo: uid)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) return Text('Error');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Container(
                      alignment: Alignment.bottomCenter,
                      child: LinearProgressIndicator());
                default:
                  print("build userline");
                  return makeBody(context, snapshot.data.documents);
              }
            })
      ],
    ));
  }

  Widget _buildTopicsText() {
    if (_buildChoiceList(_topicsList) == null) {
      return Container(height: 0);
    } else {
      return Text(
        firstName + "'s topics:",
        textAlign: TextAlign.right,
        style: TextStyle(),
      );
    }
  }

  Widget _buildTopicsContainer() {
    if (_buildChoiceList(_topicsList) == null) {
      return Container(height: 0);
    } else {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Wrap(
          children: _buildChoiceList(_topicsList),
        ),
      );
    }
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
                  child: Text('Close', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                  }),
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

  Widget makeListTile(BuildContext context, Post post) {
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
                var route = MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ProfilePage(userPage: post.uid));
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
        post.content,
        style: TextStyle(fontSize: 11),
      ),
    );
  }

  Widget buildBackButton(BuildContext context, Size screensize) {
    return SizedBox(
        child: Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        height: screensize.height / 20);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // _buildCoverImage(screenSize),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  buildBackButton(context, screenSize),
                  _buildProfileImage(),
                  SizedBox(height: 10.0),
                  _buildFullName(context),
                  _buildStatContainer(context),
                  SizedBox(height: 10.0),
                  _buildTopicsText(),
                  _buildTopicsContainer(),
                  _buildBio(context),
                  // _buildDemoButton(),
                  _buildButtons(context),
                  _buildSeparator(screenSize),
                  // _buildNoPosts(context),
                  _makeBody(context),
                  // buildUserline(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
