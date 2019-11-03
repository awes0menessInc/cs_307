exports = {}

// As a logged-in user, when I view a userline/timeline, I should see posts
// starting with the most recent posts at the top so that I can stay up-to-date
// with the newest content.

// retrieve microblogs to populate a USERLINE VIEW
exports.getUserMicroblogs = function(req, res, admin) {
  var contents = [];
  var userId = req.params.id;
  var db = admin.firestore();
  db.collection("users")
    .get(userId)
    .then(snapshot => {
      snapshot.forEach(doc => {
        var object = {
          id: doc.id,
          content: doc.data().content,
          likes: doc.data().likes,
          quotes: doc.data().quotes,
          timestamp: doc.data().timestamp,
          topics: doc.data().topics,
          username: doc.data().username
        };
        contents = contents.concat(object);
      });
      res.send(contents);
      return "";
    })
    .catch(error => {
      res.send(error);
    });
};

// function get_user_microblogs(id) {
//     var contents = [];
//     var db = admin.firestore();
//     db.collection("users").get(id).then(snapshot => {
//         snapshot.forEach(doc => {
//             var object = {
//                 "id": doc.id,
//                 "content": doc.data().content,
//                 "likes": doc.data().likes,
//                 "quotes": doc.data().quotes,
//                 "timestamp": doc.data().timestamp,
//                 "topics": doc.data().topics,
//                 "username": doc.data().username
//             }
//             contents = contents.concat(object);
//         });
//         return contents;
//     }).catch(error => {
//         res.send(error)
//     })
// }

// function get_chronological_order (microblogs) {

// }

// retrieve microblogs to populate a TIMELINE VIEW
// exports.getAllMicroblogs = functions.https.onRequest((req, res) => {
//     var db = admin.firestore();
//     var ref = db.chil
//     var contents = [];

//     db.collection.('users').get(userId).then(doc => {

//         // query to get all microblogs of user whose topics exist in topics_following
//         // OR
//         // query microblogs collection where user exists in users_following and topic exists in topics_following

//         var following = doc.data().following;
//         for (let i = 0; i < following.length; i++) {
//             let id = following[i];

//             contents.add(get_user_microblogs(id));
//         }

//     }).catch(error => {
//         res.send(error)
//     })
// });

// db.collection("cities").doc("SF")
//   .get()
//   .then(function(doc) {
//     if (doc.exists) {
//       console.log("Document data:", doc.data());
//     } else {
//       // doc.data() will be undefined in this case
//       console.log("No such document!");
//     }
//   }).catch(function(error) {
//     console.log("Error getting document:", error);
//   });

// As a logged-in user, I should have the option to create a new microblog
// directly from my timeline so that I can easily post to my timeline.

exports.postMicroblog = function(req, res, admin) {
  var blog = req.body;

  var db = admin.firestore();
  // add to microblog collection
  var blogDoc = db.collection("microblogs").doc();
  blogDoc.set(blog);

  // add ref to microblogs in user doc in user collection
  res.send("Added new microblog successfully: " + blogDoc.id);
  return db.collection("users")
    .doc(blog.userId)
    .update({
      microblogs: admin.firestore.FieldValue.arrayUnion(blogDoc.id)
    });
  // db.collection('microblogs').add(req.body).then(snapshot => {
  //     res.send('Added new microblog successfully: ', snapshot.id);
  //     return "";
  //   }).catch(error => {
  //     res.send(error);
  // });

  // add ref to microblogs in user doc in user collection
  // db.collection('users').doc(blog.userId).update({
  //     microblogs: admin.firestore.FieldValue.arrayUnion()
  // });
};
