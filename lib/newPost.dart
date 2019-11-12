import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:twistter/home.dart';
import 'package:twistter/profile.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twistter/user.dart';

class NewPost extends StatefulWidget {
  NewPost({Key key, this.current_user}) : super(key: key);
  User current_user;

  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final GlobalKey<FormState> _NewPostFormKey = GlobalKey<FormState>();
  var t = ["Purdue", "Science"];
  var dropdownvalue;
  var top = "";
  // TextEditingController postEditingController;
  ProfilePageState pps = new ProfilePageState();
  FirebaseUser currentUser;
  String _firstName = "";
  String _lastName = "";
  List<String> _topic = [""];
  String _dropdownvalue = "";
  TextEditingController postEditingController = new TextEditingController();

  initState() {
    super.initState();
    _getUser();
  }

  Future _getUser() async {
    await FirebaseAuth.instance.currentUser().then((currentuser) => {
          Firestore.instance
              .collection("users")
              .document(currentuser.uid)
              .get()
              .then((DocumentSnapshot snapshot) => {
                    setState(() {
                      _firstName = snapshot["firstName"];
                      _lastName = snapshot["lastName"];
                      _topic = List.from(snapshot["topics"]);
                      _dropdownvalue = _topic[0];
                    })
                  })
        });
  }
  
  // void _getCurrentUser() {
  //   FirebaseAuth.instance.currentUser().then((currentuser) => {
  //     Firestore.instance.collection("users").document(currentuser.uid).get()
  //     .then((DocumentSnapshot snapshot) => {
  //       setState(() {
  //         _firstName = snapshot["firstName"];
  //         _lastName = snapshot["lastName"];
  //         _topic = List.from(snapshot["topics"]);
  //         _dropdownvalue = _topic[0];
  //       })
  //     })
  //   });
  // }

  // void _getUser() {
  //   _firstName = current_user.firstName;
  // }

  void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
  }

  final HttpsCallable post_blog = CloudFunctions.instance.getHttpsCallable(
    functionName: 'postMicroblog',
  );

  Widget build(BuildContext context) {
    pps.getUserInfo();
    return Scaffold(
      appBar: AppBar(
        title: Text("NewPost"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_comment),
            onPressed: () async {
              FirebaseAuth.instance.currentUser()
              .then((currentUser) => Firestore.instance.collection("users")
              .document(currentUser.uid).get().then((doc) => Firestore.instance
                .collection('microblogs').document().setData({
                  'content': postEditingController.text,
                  'likes': '0',
                  'quotes': '0',
                  'timestamp': new DateTime.now().millisecondsSinceEpoch,
                  'topics': [dropdownvalue], // fix topics list and ui part
                  'userId': currentUser.uid,
                  // 'userName': getUsername(),
                  'firstName': _firstName,
                  'lastName': _lastName,
                })
              )
              // post_blog.call(<String, dynamic>{
              //   'content': postEditingController.text,
              //   'likes': '0',
              //   'quotes': '0',
              //   'timestamp': new DateTime.now().millisecondsSinceEpoch,
              //   'topics': [dropdownvalue],
              //   'userId': currentUser.uid,                
              //   'firstName': _firstName,
              //   'lastName': _lastName,
              //   })
              .then((result) => {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(
                      uid: currentUser.uid,
                      )),
                      (_) => false),
                      postEditingController.clear()
              }).catchError((err) => print(err))
              .catchError((err) => print(err)));
              },
            )
          ],
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: new Theme(
                data: ThemeData(
                    brightness: Brightness.light,
                    backgroundColor: Color.fromRGBO(85, 176, 189, 1.0)),
                child: SingleChildScrollView(
                    child: Form(
                        child: Column(children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Create New Post',
                      hintText: "Write Something?",
                    ),
                    maxLines: 7,
                    autofocus: true,
                    showCursor: true,
                    autocorrect: false,
                    textAlign: TextAlign.left,
                    keyboardAppearance: Brightness.dark,
                    controller: postEditingController,
                    maxLength: 307,
                  ),
                  DropdownButton<String>(
                    items: _topic.map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    value: _dropdownvalue,
                    onChanged: (String val) {
                      top = val;
                      setState(() {
                        _dropdownvalue = val;
                      });
                    },
                  ),
                  // add(),
                  // cancel()
                ]))))));
  }

  // Widget add() {
  //   return new Container(
  //     child: FloatingActionButton(
  //         tooltip: 'Create Post',
  //         child: Icon(Icons.add),
  //         heroTag: 1,
  //         onPressed: () {
  //           FirebaseAuth.instance
  //               .currentUser()
  //               .then((currentUser) => Firestore.instance
  //                   .collection("users")
  //                   .document(currentUser.uid)
  //                   .get()
  //                   .then((doc) => Firestore.instance
  //                           .collection('microblogs')
  //                           .document()
  //                           .setData({
  //                         'content': postEditingController.text,
  //                         'likes': '0',
  //                         'quotes': '0',
  //                         'timestamp':
  //                             new DateTime.now().millisecondsSinceEpoch,
  //                         'topics': [
  //                           dropdownvalue
  //                         ], // fix topics list and ui part
  //                         'userId': currentUser.uid,
  //                       }))
  //                   .then((result) => {
  //                         Navigator.pushAndRemoveUntil(
  //                             context,
  //                             MaterialPageRoute(
  //                                 builder: (context) => Home(
  //                                     // uid: currentUser.uid,
  //                                     )),
  //                             (_) => false),
  //                         postEditingController.clear()
  //                       })
  //                   .catchError((err) => print(err)))
  //               .catchError((err) => print(err));
  //         }),
  //     margin: const EdgeInsets.all(10.0),
  //   );
  // }

  // Widget cancel() {
  //   return new Container(
  //     child: FloatingActionButton(
  //         tooltip: 'Cancel Post',
  //         child: Icon(Icons.cancel),
  //         heroTag: 0,
  //         onPressed: () {
  //           Navigator.of(context).pushReplacement(MaterialPageRoute(
  //             builder: (context) => Home(),
  //           ));
  //         }),
  //     margin: const EdgeInsets.all(10.0),
  //   );
  // }
// class NewPost extends StatelessWidget {
//   TextEditingController newPost = TextEditingController();
//   String dropdownValue = 'Purdue';
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(
//             "twistter",
//             style: TextStyle(
//                 color: Color(0xff032B30),
//                 fontFamily: 'Amaranth',
//                 fontWeight: FontWeight.bold,
//                 fontStyle: FontStyle.italic,
//                 fontSize: 27),
//           ),
//           backgroundColor: Colors.white,
//         ),
//         drawer: new Drawer(),
//         floatingActionButton: new Row(
//           children: <Widget>[
//             new Padding(
//               padding: new EdgeInsets.symmetric(
//                 horizontal: 10.0,
//               ),
//             ),
//             new FloatingActionButton(
//               child: Icon(Icons.cancel),
//               backgroundColor: Color(0xff55b0bd),
//               heroTag: 0,
//               onPressed: () {
//                 Navigator.of(context).pushReplacement(MaterialPageRoute(
//                   builder: (context) => Home(),
//                 ));
//               },
//             ),
//             new Padding(
//               padding: new EdgeInsets.symmetric(
//                 horizontal: 138.0,
//               ),
//             ),
//             new FloatingActionButton(
//               child: Icon(Icons.add_comment),
//               backgroundColor: Color(0xff55b0bd),
//               heroTag: 1,
//               onPressed: () {
//                 Navigator.of(context).pushReplacement(MaterialPageRoute(
//                   builder: (context) => Home(),
//                 ));
//               },
//             ),
//           ],
//         ),
//         body: Center(
//           child: Card(
//             elevation: 8.0,
//             margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 const ListTile(
//                   leading: Icon(Icons.account_circle),
//                   title: Text('Write Something?'),
//                 ),
//                 new Expanded(
//                   //flex: 3,
//                   child: new TextFormField(
//                     maxLines: 7,
//                     autofocus: true,
//                     showCursor: true,
//                     autocorrect: false,
//                     textAlign: TextAlign.left,
//                     keyboardAppearance: Brightness.dark,
//                     controller: newPost,
//                   ),
//                 ),
//                 new Expanded(
//                   child: DropdownButton<String>(
//                     value: dropdownValue,
//                     icon: Icon(Icons.title),
//                     elevation: 10,
//                     underline: Container(
//                       height: 2,
//                       color: Color(0xff55b0bd),
//                     ),
//                     onChanged: (String newValue) {
//                       dropdownValue = newValue;
//                     },
//                     items: <String>['Purdue']
//                         .map<DropdownMenuItem<String>>((String value) {
//                       return DropdownMenuItem<String>(
//                         child: Text(value),
//                         value: value,
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           //child: TextFormField(
//           //decoration: InputDecoration(labelText: 'Write Post'),
//         ));
//   }
}
