import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:twistter/auth_service.dart';
import 'package:twistter/post.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import 'package:twistter/metrics.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:twistter/repost.dart';

class ProfilePage extends StatefulWidget {
  String userPage;
  ProfilePage({Key key, this.userPage}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  String uid;
  String firstName;
  String username;
  String lastName;
  String email;
  String bio;

  int followers;
  int following;
  int _posts = 199;
  // int _topics = 333;

  // List<String> postsList;
  List<String> topics;
  List<Post> posts = [];
  int followersNum;
  int followingNum;
  int postNum;

  bool pressed = false;
  bool isAccountOwner = true; // TODO: Connect to a function on the back end
  bool emailPrivate;

  File _image;

  Color _iconColor = Color.fromRGBO(5, 62, 66, 1.0);
  Color _iconColorPressed = Color.fromRGBO(214, 59, 47, 1.0);
  Icon _icon = Icon(Icons.favorite_border, size: 20);
  Icon _iconPressed = Icon(Icons.favorite, size: 20);

  @override
  initState() {
    getUserInfo();
    super.initState();
  }

  // void getUserInfo() async {
  //   final FirebaseUser user = await FirebaseAuth.instance.currentUser();
  //   var userQuery = Firestore.instance.collection('users').where('uid', isEqualTo: user.uid).limit(1);
  //   userQuery.getDocuments().then((data) {
  //     if (data.documents.length > 0) {
  //       setState(() {
  //         firstName = data.documents[0].data['firstName'];
  //         lastName = data.documents[0].data['lastName'];
  //         email = data.documents[0].data['email'];
  //         username = data.documents[0].data['username'];
  //         bio = data.documents[0].data['bio'];
  //         // followers = data.documents[0].data['followers'].toString();
  //         // following = data.documents[0].data['following'].toString();
  //         // _posts = data.documents[0].data['microblogs'].length().toString();
  //       });
  //     }
  //   });
  // }

  void getUserInfo() {
    uid = AuthService.currentUser.uid;
    firstName = AuthService.currentUser.firstName;
    lastName = AuthService.currentUser.lastName;
    email = AuthService.currentUser.email;
    username = AuthService.currentUser.username;
    bio = AuthService.currentUser.bio;

    followers = AuthService.currentUser.followers;
    following = AuthService.currentUser.following;
    _posts = AuthService.currentUser.posts;
    followersNum = AuthService.currentUser.followersList.length;
    followingNum = AuthService.currentUser.followingList.length - 1;
    postNum = AuthService.currentUser.postsList.length;
    emailPrivate = AuthService.currentUser.emailIsPrivate;

    // topics = List.from(AuthService.currentUser.topicsList);

    // postsList = AuthService.currentUser.postsList;
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 400, maxWidth: 400);

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

  Widget _buildEmail() {
    if (emailPrivate) {
      return Container(height: 0);
    } else {
      return Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            email,
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.black,
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
            ),
          ));
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
        Text(count, style: _statCountTextStyle),
        Text(label, style: _statLabelTextStyle),
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
            child: _buildStatItem("Followers", followersNum.toString()),
            onTap: () {
              Navigator.pushNamed(context, "/followers");
            },
          ),
          InkWell(
            child: _buildStatItem("Following", followingNum.toString()),
            onTap: () {
              Navigator.pushNamed(context, "/following");
            },
          ),
          _buildStatItem("Posts", postNum.toString()),
        ],
      ),
    );
  }

  Widget _buildBio(BuildContext context) {
    TextStyle bioTextStyle = TextStyle(
      fontFamily: 'Spectral',
      fontWeight: FontWeight.w600,
      color: Colors.black,
      fontSize: 16.0,
    );
    if (bio != null && bio != "") {
      return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: EdgeInsets.all(8.0),
        child: Text(
          bio,
          textAlign: TextAlign.center,
          style: bioTextStyle,
        ),
      );
    } else {
      return Container(height: 0);
    }
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
    if (pressed) {
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
    snap.forEach((post) {
      posts.add(Post(
          content: post['content'],
          username: post['username'],
          fullName:
              post['firstName'].toString() + " " + post['lastName'].toString(),
          topics: List.from(post['topics']),
          uid: post['uid'],
          likes: List.from(post['likes']),
          postID: post['postID'],
          timestamp: post['timestamp']));
    });
    return posts;
  }

  Widget makeBody(BuildContext context, List<DocumentSnapshot> snap) {
    if (snap == null) {
      return _buildNoPosts(context);
    } else {
      posts = getPosts(snap);
      List<Widget> cards = List();
      int index = 0;
      posts.forEach((post) {
        cards.add(makeCard(context, post, index));
        index++;
      });
      return Column(children: cards);
    }
  }

  Widget makeCard(BuildContext context, Post post, int index) {
    return Card(
        elevation: 8,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(child: makeListTile(context, post)),
            SizedBox(
                height: 70,
                child: ButtonBar(
                  children: <Widget>[
                    SizedBox(
                        width: 25,
                        child: IconButton(
                          icon: Icon(Icons.assignment, size: 19),
                          color: Color.fromRGBO(5, 62, 66, 1.0),
                          onPressed: () => showTags(context, post),
                        )),
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
                )),
          ],
        ));
  }

  Widget buildUserline(BuildContext context) {
    return Stack(
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
              if (snapshot.data == null) {
                return makeBody(context, null);
              }
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Container(
                      alignment: Alignment.bottomCenter,
                      child: LinearProgressIndicator());
                default:
                  return makeBody(context, snapshot.data.documents);
              }
            })
      ],
    );
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
                // onTap: () {
                //   print("tap!");
                //   var route = MaterialPageRoute(
                //       builder: (BuildContext context) =>
                //           ProfilePage(userPage: post.uid));
                //   Navigator.of(context).push(route);
                // },
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
        trailing: Text(
            timeago.format(DateTime.fromMillisecondsSinceEpoch(post.timestamp)),
            style: TextStyle(fontSize: 11)));
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(height: screenSize.height / 20),
            _buildProfileImage(),
            SizedBox(height: 10.0),
            _buildFullName(context),
            _buildEmail(),
            _buildStatContainer(context),
            _buildBio(context),
            _buildButtons(context),
            // _buildSeparator(screenSize),
            buildUserline(context),
          ],
        ),
      ),
    );
  }
}
