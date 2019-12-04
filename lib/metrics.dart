import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twistter/post.dart';
import 'package:twistter/user.dart';
import 'package:twistter/auth_service.dart';

bool sortFlag = false;

void like(post, userID) async {
  if (post.likes.contains(userID)) {
    post.likes.remove(userID);
    Firestore.instance
        .collection('posts')
        .document(post.postID)
        .updateData({"likes": post.likes});

    Map<String, dynamic> updateData = {};
    String postUser = post.uid;
    post.topics.forEach((topic) =>
        updateData["followingUserTopicList.$postUser.Following.$topic"] =
            FieldValue.increment(-1));
    Firestore.instance
        .collection('users')
        .document(userID)
        .updateData(updateData);
  } else {
    post.likes.add(userID);
    Firestore.instance
        .collection('posts')
        .document(post.postID)
        .updateData({"likes": post.likes});

    Map<String, dynamic> updateData = {};
    String postUser = post.uid;
    post.topics.forEach((topic) =>
        updateData["followingUserTopicList.$postUser.Following.$topic"] =
            FieldValue.increment(1));
    Firestore.instance
        .collection('users')
        .document(userID)
        .updateData(updateData);
  }
}

void setSort(bool sort) async {
  sortFlag = sort;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("sort", sort);
}

List<Post> sortPosts(List<Post> posts) {
  if (!sortFlag) return posts;

  Map<String, int> userScore = {}, topicScore = {};
  int time = new DateTime.now().millisecondsSinceEpoch;

  //Fetch latest user
  AuthService.initUser(AuthService.currentUser.uid);

  // Update score
  AuthService.currentUser.followingUserTopicList.forEach((user, userMap) {
    userMap["Following"].forEach((topic, score) {
      topicScore.update(topic, (dynamic val) => val + score,
          ifAbsent: () => score);
      userScore.update(user, (dynamic val) => val + score,
          ifAbsent: () => score);
    });
  });

  // print(posts[0].score);
  posts.forEach((post) {
    post.topics.forEach((topic) => post.score += topicScore[topic]);
    post.score += 0.5 * userScore[post.uid];
    post.score +=
        Duration(minutes: 10).inMilliseconds / (time - post.timestamp);
    // print(post.score);
  });

  posts.sort((b, a) => a.score.compareTo(b.score));

  return posts;
}

List<User> sortFollowing(List<User> users) {
  if (!sortFlag) return users;

  Map<String, int> userScore = {};

  //Fetch latest user
  AuthService.initUser(AuthService.currentUser.uid);

  // Update score
  AuthService.currentUser.followingUserTopicList.forEach((user, userMap) {
    userMap["Following"].forEach((topic, score) {
      userScore.update(user, (dynamic val) => val + score,
          ifAbsent: () => score);
    });
  });

  // print(users[0].score);
  users.forEach((user) {
    user.score = userScore[user.uid];
  });

  users.sort((b, a) => a.score.compareTo(b.score));

  return users;
}

List<User> sortFollowers(List<User> users) {
  // if (!sortFlag) return users;

  // Map<String, int> userScore = {};

  // //Fetch latest user
  // AuthService.initUser(AuthService.currentUser.uid);

  // // Update score
  // AuthService.currentUser.followingUserTopicList.forEach((user, userMap) {
  //   userMap["Following"].forEach((topic, score) {
  //     userScore.update(user, (dynamic val) => val + score,
  //         ifAbsent: () => score);
  //   });
  // });

  // // print(users[0].score);
  // users.forEach((user) {
  //   user.score = userScore[user.uid];
  // });

  // users.sort((b, a) => a.score.compareTo(b.score));

  return users;
}
