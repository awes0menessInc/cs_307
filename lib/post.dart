class Post {
  String uid;
  String username;
  String fullName;
  String content;
  List<String> topics;
  int timestamp;
  String postID;
  double score = 0.0;

  List<String> likes;

  Post(
      {this.username,
      this.fullName,
      this.content,
      this.topics,
      this.uid,
      this.timestamp,
      this.likes,
      this.postID,
      this.score});
}

class PostList {
  List<Post> postList;
  PostList({this.postList});
}
