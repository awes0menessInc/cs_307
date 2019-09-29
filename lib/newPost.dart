import 'package:flutter/material.dart';

class NewPost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text("Make a New Post!"),
     ),
     body: Center(
       child: Text('New Post'),
       )
   );
  }
}