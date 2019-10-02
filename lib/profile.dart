import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  final String _fullName = "Rebecca Keys";
  final String _status = "Software Developer";
  final String _bio =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Varius sit amet mattis vulputate enim nulla. Malesuada fames ac turpis egestas. In dictum non consectetur a erat nam at lectus urna. Id venenatis a condimentum vitae sapien pellentesque habitant morbi tristique.";
  final String _followers = "450";
  final String _following = "127";
  final String _posts = "24";
  bool _followStatus = false;
  String _followText = "FOLLOW";
// TODO: grab the logged in user upon login so this field can be properly filled out
  String _viewingUser = "Rebecca Keys"; // currently a mock of the logged in user.

  // Widget _buildCoverImage(Size screenSize) {
  //   return Container(
  //     height: screenSize.height / 3,
  //     decoration: BoxDecoration(
  //       image: DecorationImage(
  //         image: AssetImage('lib/assets/images/cover.jpeg'),
  //         fit: BoxFit.cover,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildProfileImage() {
    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/images/profile_image.jpg'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: Colors.white,
            width: 2.0,
          ),
        ),
      ),
    );
  }

  Widget _buildFullName(BuildContext context) {
    // TextStyle _nameTextStyle = TextStyle(
    //   fontFamily: 'Roboto',
    //   color: Colors.black,
    //   fontSize: 28.0,
    //   fontWeight: FontWeight.w700,
    // );

    // return Text(
    //   _fullName,
    //   style: _nameTextStyle,
    // );
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(4.0),
        // margin: EdgeInsets.only(top: 8.0),
      ),
      child: Text(
        _fullName,
        style: TextStyle(
          fontFamily: 'Spectral',
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildStatus(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        _status,
        style: TextStyle(
          fontFamily: 'Spectral',
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    TextStyle _statLabelTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 16.0,
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

  Widget _buildStatContainer() {
    return Container(
      height: 60.0,
      margin: EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        color: Color(0xFFEFF4F7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildStatItem("Followers", _followers),
          _buildStatItem("Following", _following),
          _buildStatItem("Posts", _posts),
        ],
      ),
    );
  }

  Widget _buildBio(BuildContext context) {
    TextStyle bioTextStyle = TextStyle(
      fontFamily: 'Spectral',
      fontWeight: FontWeight.w400, //try changing weight to w500 if not thin
      fontStyle: FontStyle.italic,
      color: Color(0xFF799497),
      fontSize: 16.0,
    );

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.all(8.0),
      child: Text(
        _bio,
        textAlign: TextAlign.center,
        style: bioTextStyle,
      ),
    );
  }

  Widget _buildSeparator(Size screenSize) {
    return Container(
      width: screenSize.width / 1.6,
      height: 2.0,
      color: Colors.black54,
      margin: EdgeInsets.only(top: 4.0),
    );
  }

  Widget _buildButtons(BuildContext context) {
    bool showEdit = _fullName == _viewingUser;
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _followStatus = !(_followStatus);
                      if (_followStatus) {
                        _followText = "FOLLOWING";
                        print("Following");
                      } else {
                        _followText = "FOLLOW";
                        print("Unfollowed");
                      }
                    },
                    child: Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(15.0),
                        color: Color(0xff077188),
                      ),
                      child: Center(
                        child: Text(
                          "$_followText",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // SizedBox(width: 10.0),
                // Expanded(
                //   child: InkWell(
                //     onTap: () => print("Message"),
                //     child: Container(
                //       height: 40.0,
                //       decoration: BoxDecoration(
                //         border: Border.all(),
                //       ),
                //       child: Center(
                //         child: Padding(
                //           padding: EdgeInsets.all(10.0),
                //           child: Text(
                //             "MESSAGE",
                //             style: TextStyle(fontWeight: FontWeight.w600),
                //             ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
            Row(
              children: <Widget>[
                Visibility(
                  visible: showEdit,
                  child: Expanded( 
                    child: Container(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: new FlatButton(
                            child: Text("EDIT PROFILE"),
                            shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(15.0)),
                            color: Color(0xff077188),
                            textColor: Colors.white,
                            onPressed: () {
                              showDialog( // TODO: replace with call to actual profile edit UI
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: new Text("Edit Profile"),
                                    content: Form(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              decoration: new InputDecoration(
                                                hintText: 'Bio'
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              decoration: new InputDecoration(
                                                hintText: 'First Name'
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              decoration: new InputDecoration(
                                                hintText: 'Last Name'
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              decoration: new InputDecoration(
                                                hintText: 'Email '
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: RaisedButton(
                                              child: Text("Submit"),
                                              onPressed: () {
                                                print("Form submit");
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              );
                            }, 
                          ),
                        )  
                      )
                    )
                  )  
                )
              ],
            ),
          ],
        ));
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
                  SizedBox(height: screenSize.height / 20),
                  _buildProfileImage(),
                  _buildFullName(context),
                  _buildStatus(context),
                  _buildStatContainer(),
                  _buildBio(context),
                  _buildSeparator(screenSize),
                  SizedBox(height: 10.0),
                  SizedBox(height: 8.0),
                  _buildButtons(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
