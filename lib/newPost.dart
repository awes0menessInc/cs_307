import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:twistter/auth_service.dart';
import 'package:twistter/home.dart';

class NewPost extends StatefulWidget {
  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  TextEditingController postEditingController = new TextEditingController();
  var dropdownvalue;
  bool isSelected = false;

  String uid;
  String firstName;
  String lastName;
  String username;
  List<String> topics;

  initState() {
    super.initState();
    getUser();
  }

  void getUser() {
    uid = AuthService.currentUser.uid;
    firstName = AuthService.currentUser.firstName;
    lastName = AuthService.currentUser.lastName;
    username = AuthService.currentUser.username;
    topics = List.from(AuthService.currentUser.topicsList);
  }

  List<String> selectedTopics = List();
  List<Widget> _buildChoiceList(List<String> topic) {
    topic.removeWhere((item) =>
        item ==""); //removes any empty strings from the topic list before displaying
    if (topic.length == 0) {
      return null;
    }
    List<Widget> choices = List();
    topic.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedTopics.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedTopics.contains(item)
                  ? selectedTopics.remove(item)
                  : selectedTopics.add(item);
            });
          },
        ),
      ));
    });
    return choices;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create New Post"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () async {
                if (selectedTopics != null && selectedTopics.isNotEmpty) {
                  Firestore.instance
                      .collection('posts')
                      .add({
                        'content': postEditingController.text,
                        'likes': [""],
                        'quotes': 0,
                        'timestamp': new DateTime.now().millisecondsSinceEpoch,
                        'topics': FieldValue.arrayUnion(List.from(
                            selectedTopics)), // fix topics list and ui part
                        'uid': uid,
                        'username': username,
                        'firstName': firstName,
                        'lastName': lastName,
                      })
                      .then((value) => Firestore.instance
                              .collection('users')
                              .document(uid)
                              .updateData({
                            'postsList':
                                FieldValue.arrayUnion([value.documentID]),
                          }))
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
                } else {
                  return showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Unable to post"),
                          content:
                              Text('Please select a topic before you post'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      });
                }
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
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Create New Post',
                          hintText: "Write something!",
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
                      Wrap(
                        children: _buildChoiceList(topics),
                      )
                    ],
                  ),
                )))));
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
  //                           .collection('posts')
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
