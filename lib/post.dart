class Post {
  String uid;
  String username;
  String fullName;
  String content;
  List<String> topics;
  int timestamp;
  List<String> likes;

  // List<String> likes;

  // List<String> topics;

  Post(
      {this.username,
      this.fullName,
      this.content,
      this.topics,
      this.uid,
      this.timestamp,
      this.likes});
}

class PostList {
  List<Post> postList;
  PostList({this.postList});
}
