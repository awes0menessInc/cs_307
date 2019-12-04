class User {
  String uid;
  String username;
  String firstName;
  String lastName;
  String email;
  String bio;
  String website;

  DateTime birthday;

  int followers;
  int following;
  int posts;
  int topics;
  int score;

  List<String> followersList;
  List<String> followingList;
  List<String> postsList;
  List<String> topicsList;
  Map<String, dynamic> followingUserTopicList;

  bool emailIsPrivate;

  User({
    this.uid,
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.bio,
    this.website,
    this.birthday,
    this.followers,
    this.following,
    this.posts,
    this.topics,
    this.followersList,
    this.followingList,
    this.postsList,
    this.topicsList,
    this.followingUserTopicList,
    this.score,
    this.emailIsPrivate,
  });
}
