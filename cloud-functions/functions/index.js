// // The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
// const functions = require('firebase-functions');
//
// // The Firebase Admin SDK to access the Firebase Realtime Database.
// const admin = require('firebase-admin');
// admin.initializeApp();

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);


exports.test = functions.https.onRequest((req, res) => {
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

//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
