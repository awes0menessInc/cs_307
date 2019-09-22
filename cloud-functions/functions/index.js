
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.testGet = functions.https.onRequest((req, res) => {
    var contents = [];
    var db = admin.firestore();
    db.collection("test").get().then(snapshot => {
        snapshot.forEach(doc => {
            var v = {
                "id": doc.id,
                "message": doc.data().message
            }
            contents = contents.concat(v); 
        });
        res.send(contents)
        return "";
    }).catch(reason => {
        res.send(reason)
    })
});

exports.testPost = functions.https.onRequest((req, res) => {
    var db = admin.firestore();
    db.collection("test").add(req.body).then(snapshot => {
        res.send('Added new document');
        return "";
    }).catch (exception => {
        res.send(exception)
    })
});

// As a logged-in user, when I view a userline/timeline, I should see posts
// starting with the most recent posts at the top so that I can stay up-to-date
// with the newest content.

exports.getUserMicroblogs = functions.https.onRequest((req, res) => {
    var contents = [];
    var userId = req.params.id;
    var db = admin.firestore();
    db.collection("users").get(userId).then(snapshot => {
        snapshot.forEach(doc => {
            var object = {
                "id": doc.id,
                "content": doc.data().content,
                "likes": doc.data().likes,
                "quotes": doc.data().quotes,
                "timestamp": doc.data().timestamp,
                "topics": doc.data().topics,
                "username": doc.data().username
            }
            contents = contents.concat(object);
        });
        res.send(contents)
        return "";
    }).catch(error => {
        res.send(error)
    })
});

// As a logged-in user, I should have the option to create a new microblog
// directly from my timeline so that I can easily post to my timeline.

exports.postMicroblog = functions.https.onRequest((req, res) => {

    var db = admin.firestore();
    // add to microblog collection
    db.collection('microblogs').add(req.body).then(snapshot => {
        res.send('Added new microblog successfully');
        return "";
      }).catch(error => {
        res.send(error);
    });

    // // add ref to microblogs in user doc in user collection
    // db.collection("users").get(userId).then(snapshot => {
    //     snapshot.forEach(doc => {
    //         var object = {
    //             "id": doc.id,
    //             "content": doc.data().content,
    //             "likes": doc.data().likes,
    //             "quotes": doc.data().quotes,
    //             "timestamp": doc.data().timestamp,
    //             "topics": doc.data().topics,
    //             "username": doc.data().username
    //         }
    //         contents = contents.concat(object);
    //     });
    //     res.send(contents)
    //     return "";
    // }).catch(error => {
    //     res.send(error)
    // })
});
