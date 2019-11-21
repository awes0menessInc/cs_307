class User {
  String uid;
  String username;
  String firstName;
  String lastName;
  String email;
  String bio;
  String birthday;
  String website;

  String numFollowers;
  String numFollowing;
  int numMicroblogs;

  // List<String> followers;
  List<String> following;
  // List<String> microblogs;
  
  List<String> topics; 

  User({
    this.uid,
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.bio,
    this.birthday,
    this.website,

    this.numFollowers,
    this.numFollowing,
    this.numMicroblogs,

    // List<String> followers,
    this.following,
    // List<String> microblogs,
    this.topics,
    }
  );
}