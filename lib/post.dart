class Post {
  final String uid;
  final String username;
  final String fullName;
  final String content;
  final List<String> topics;
  // final List<String> likes;
  
  //final String topics;

  const Post({this.username, this.fullName, this.content, this.topics, this.uid});

}

class PostList{
  List<Post> postList;
  PostList({this.postList});

}