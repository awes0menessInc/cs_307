import 'package:flutter/material.dart';

class Timeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(primaryColor: Colors.white),
      home: new ListPage(title: 'Timeline'),
    );
  }
}

// class Tweet extends StatelessWidget {
  
//   Tweet({this.user, this.userHandle, this.text});
//   final String user;
//   final String userHandle;
//   final String text; 

//   @override 
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(10.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border(bottom: BorderSide())
//         ),
//       child: new Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           CircleAvatar(
//             child: Text(user.substring(0,1)),
//           ),
//           _tweetContent()
//         ],
//       ),
//       );
//   }

//   Widget _tweetContent(){
//     return Flexible(
//       child: Container(
//         margin: EdgeInsets.only(left: 10.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             Row(
//               children: <Widget>[
//                 Text(user,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold
//                     )),
//                 Container(
//                   margin: EdgeInsets.only(left: 5.0),
//                   child: Text(userHandle + " 30m",
//                     style: TextStyle(color: Colors.grey[400])),
//                 )
//               ],
//             ),
            
//           ],
//         ),
//       ),
//     );
//   }
// }

class ListPage extends StatefulWidget {
  ListPage({Key key, this.title}) : super(key: key);
  final String title; 

  @override 
  _ListPageState createState() => _ListPageState();

}

class _ListPageState extends State<ListPage> {
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(85, 176, 189, 1.0),
      body: makeBody,
    );
  }

  final makeBody = Container(
    child: ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return makeCard;
      },
      ),
  );

  static final makeCard = Card(
    elevation: 8.0,
    margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    child: Container(
      decoration: BoxDecoration(color: Colors.white),
      child: makeListTile,
    ),
  );

  static final makeListTile = ListTile( 
    contentPadding : EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading : Container(
      padding: EdgeInsets.only(right: 5.0),
      child: Icon(Icons.account_circle,
      size: 45.0),
    ),
    title: Text(
      "BoilerMaker",
      style: TextStyle(color: Color.fromRGBO(7, 113, 136, 1.0), fontWeight: FontWeight.bold, fontSize: 12),
    ),
    subtitle: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
    style: TextStyle(fontSize: 11)),

    trailing: Row(
          mainAxisSize : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(Icons.favorite,
            size: 20.0),
            Icon(Icons.add_comment,
            size: 20.0)
          ]
        ),
  );
}
