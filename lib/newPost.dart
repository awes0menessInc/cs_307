import 'package:flutter/material.dart';
import 'package:twistter/home.dart';
import 'package:twistter/timeline.dart';
import 'package:cloud_functions/cloud_functions.dart';

class NewPost extends StatelessWidget {
  TextEditingController newPost = TextEditingController();
  String dropdownValue = 'Purdue';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "twistter",
            style: TextStyle(
                color: Color(0xff032B30),
                fontFamily: 'Amaranth',
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 27),
          ),
          backgroundColor: Colors.white,
        ),
        drawer: new Drawer(),
        floatingActionButton: new Row(
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
            ),
            new FloatingActionButton(
              child: Icon(Icons.cancel),
              backgroundColor: Color(0xff55b0bd),
              heroTag: 0,
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => Home(),
                ));
              },
            ),
            new Padding(
              padding: new EdgeInsets.symmetric(
                horizontal: 138.0,
              ),
            ),
            new FloatingActionButton(
              child: Icon(Icons.add_comment),
              backgroundColor: Color(0xff55b0bd),
              heroTag: 1,
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => Home(),
                ));
              },
            ),
          ],
        ),
        body: Center(
          child: Card(
            elevation: 8.0,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('Write Something?'),
                ),
                new Expanded(
                  //flex: 3,
                  child: new TextFormField(
                    maxLines: 7,
                    autofocus: true,
                    showCursor: true,
                    autocorrect: false,
                    textAlign: TextAlign.left,
                    keyboardAppearance: Brightness.dark,
                    controller: newPost,
                  ),
                ),
                new Expanded(
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    icon: Icon(Icons.title),
                    elevation: 10,
                    underline: Container(
                      height: 2,
                      color: Color(0xff55b0bd),
                    ),
                    onChanged: (String newValue) {
                      dropdownValue = newValue;
                    },
                    items: <String>['Purdue']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        child: Text(value),
                        value: value,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          //child: TextFormField(
          //decoration: InputDecoration(labelText: 'Write Post'),
        ));
  }
}
