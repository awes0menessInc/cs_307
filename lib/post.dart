class Post {
  String uid;
  String username;
  String fullName;
  String content;
  List<String> topics;
  int timestamp;
  bool liked;
  double score;

  List<String> likes;

  Post({
    this.username,
    this.fullName,
    this.content,
    this.topics,
    this.uid,
    this.timestamp
  });

  Post.test() {
    this.username = "test123";
    this.fullName = "Test User";
    this.content = "test tweet";
    this.topics = ["Test1"];
    this.uid = "TEST123";
    this.timestamp = DateTime.now().millisecondsSinceEpoch;
  }
}
