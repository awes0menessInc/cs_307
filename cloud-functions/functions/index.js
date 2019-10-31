"use strict";

const user = require("./user");
const microblog = require("./microblog");


admin.initializeApp(functions.config().firebase);

exports.addUser = functions.https.onRequest((data, context) => {
  user.addUser(data, context, admin)
});

exports.updateUser = functions.https.onRequest((data, context) => {
  user.updateUser(data, context, admin);
});

exports.deleteUser = functions.https.onRequest((data, context) => {
  user.deleteUser(data, context, admin);
});

exports.updateProfile = functions.https.onRequest((data, context) => {
  user.updateProfile(data, context, admin);
});

exports.testGet = functions.https.onRequest((req, res) => {
  var contents = [];
  var db = admin.firestore();
  db.collection("test")
    .get()
    .then(snapshot => {
      snapshot.forEach(doc => {
        var v = {
          id: doc.id,
          message: doc.data().message
        };
        contents = contents.concat(v);
      });
      res.send(contents);
      return "";
    })
    .catch(reason => {
      res.send(reason);
    });
});

exports.testPost = functions.https.onRequest((req, res) => {
  var db = admin.firestore();
  db.collection("test")
    .add(req.body)
    .then(snapshot => {
      res.send("Added new document");
      return "";
    })
    .catch(error => {
      res.send(error);
    });
});

exports.getUserMicroblogs = functions.https.onRequest((req, res) => {
    microblog.getUserMicroblogs(req, res, admin);
});

exports.postMicroblog = functions.https.onRequest((req, res) => {
    microblog.postMicroblog(req, res, admin);
});