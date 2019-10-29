import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'post.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Timeline extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      theme: new ThemeData(primaryColor: Colors.white),
      home: new ListPage(title: 'Timeline'),
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
  final String _username = "BoilerMaker";
  final String _blogtext = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sed odio morbi quis commodo odio. Integer eget aliquet nibh praesent tristique. Semper quis lectus nulla at volutpat diam. Fringilla est ullamcorper eget nulla facilisi etiam.";
  bool pressed = false; 
  List<Post> posts = [];


  void showTags(BuildContext context, Post post) {
    AlertDialog viewTags = AlertDialog(
      title: Text('Post Tags', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Poppins')),
      content: Container( 
        child: ListView(
          padding: EdgeInsets.all(4),
          children: post.topics.map((data) => 
          Padding(
            padding: EdgeInsets.all(4),
            child: Text(
            data = "#" + data,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              
            ),
          ))
          ).toList()
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop('dialog');
          },
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

  List<Post> getPosts(List<DocumentSnapshot> snap)
  {
    List<Post> postsList = [];
    List<dynamic> tags = [];
    snap.forEach((f){
      //var s = f['topics'];
      //debugPrint("topics: " + s);
      //print(s.runtimeType);
      // s.forEach((r) {
      //   print(r.runtimeType);
      // });
      postsList.add(
        new Post(
          content: f['content'], 
          username: f['userId'],
          topics: List.from(f['topics']),
          )
      );
    });
    return postsList; 
  }

  Widget _makeBody(BuildContext context, List<DocumentSnapshot> snap) {
    posts = getPosts(snap); 
    //debugPrint("PLLLLLLLSSSSSS" + posts[1].content);
    return Container(
      child: new ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (content,index) => _makeCard(context, posts[index]),
        itemCount: posts.length,
      )
    );

  }


  Widget _makeListTile(BuildContext context, Post post) {
    //debugPrint("PLLLLLLLSSSSSS" + posts[1].content);

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 5.0),
        child: Icon(Icons.account_circle,
          size: 45.0,
          color: Color.fromRGBO(5, 62, 66, 1.0),
        )
      ),
      title: Container( 
        padding: EdgeInsets.all(0),
        child: Text(
         // _username,
         post.username,
          style: TextStyle(
            color: Color.fromRGBO(7, 113, 136, 1.0),
            fontWeight: FontWeight.bold,
            fontSize: 12,
            fontFamily: 'Poppins',
          ),
        )
      ),
      subtitle: Text(
        //_blogtext,
        post.content,
        style: TextStyle(fontSize: 11),
      ),

    );
  }

  Widget _makeCard(BuildContext context, Post post) {
    
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
                  child: Text(
                    "View Tags",
                    style: TextStyle(
                      fontSize: 10,
                      color: Color.fromRGBO(5, 62, 66, 1.0),
                    )
                  ),
                  onPressed: () => showTags(context, post),
                ),
                SizedBox(
                  width: 25,
                  child: IconButton(
                    icon: Icon(Icons.add_comment, size: 19),
                    color: Color.fromRGBO(5, 62, 66, 1.0),
                    onPressed: () => debugPrint("reblog"),
                  )
                ),
                SizedBox(
                  width: 40,
                  child: IconButton(
                    icon: Icon(Icons.favorite_border, size: 20),
                    color: Color.fromRGBO(5, 62, 66, 1.0),
                    onPressed: () => debugPrint('like'),
                  )
                ),
              ],
            )
          )
          ),
        ],


      )
    );
  }



  @override 
  Widget build(BuildContext context) {
    //Firestore.instance
    
    return Scaffold(
      backgroundColor: Color.fromRGBO(85, 176, 189, 1.0),
      body: Stack(
        children: <Widget>[
          
          StreamBuilder<QuerySnapshot>
          (
            stream: Firestore.instance.collection('microblogs')
              .snapshots(),
            builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.hasError)
                return new Text('Error');
              switch(snapshot.connectionState) 
              {
                case ConnectionState.waiting:
                  return new Text('Loading');
                default: 
                  return _makeBody(context, snapshot.data.documents);
              }//switch
            }//asyncsnapshot
          )
          
          //_makeBody(context, posts),
        ],
      )
    );
  }
}

