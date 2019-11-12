class User {
  String uid;
  String username;
  String firstName;
  String lastName;
  String email;
  String bio;
  String birthday;
  String website;

  String numFollowing;
  String numFollowers;
  String numMicroblogs;

  // List<String> microblogs;
  // List<String> following;
  // List<String> followers;
  // List<String> topics; 

  User({
    this.uid,
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.bio,
    this.birthday,
    this.website,

    this.numFollowing,
    this.numFollowers,
    this.numMicroblogs,

    // List<String> microblogs,
    // List<String> following,
    // List<String> followers,
    // List<String> topics,
    }
  );
}