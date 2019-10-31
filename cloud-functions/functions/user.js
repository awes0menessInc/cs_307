exports = {};

exports.addUser = function(data, context, admin) {
  const users = admin.firestore().collection("users");
  var user = {
    uid: data.body.uid,
    firstName: data.body.firstName,
    lastName: data.body.lastName,
    username: data.body.userName,
    bio: "",
    email: data.body.email,
    followers: [],
    following: [],
    topics: [],
    microblogs: []
  };
  users.doc(data.body.uid).set(user)
  .then(docRef => {
    console.log("User added with ID: ", docRef.uid);
    context.status(200).send("User added successfully");
    return;
  })
  .catch(error => {
    console.error("Error adding user: ", error);
    context.status(400).send("Unable to add user");
  });
};

exports.updateUser = function(data, context, admin) {
  const users = admin.firestore().collection("users");
  var user = {
    firstName: data.body.firstName,
    lastName: data.body.lastName,
    userName: data.body.userName,
    bio: data.body.bio,
    email: data.body.email,
    followers: data.body.followers,
    following: data.body.following,
    topics: data.body.topics,
    microblogs: data.body.microblogs
  };
  users.doc(data.body.userName).update(user)
  .then(docRef => {
    console.log("User updated with ID: ", docRef.id);
    context.status(200).send("User updated successfully");
    return;
  }).catch(error => {
    console.error("Error updating user: ", error);
    context.status(400).send("Unable to update user");
  });
};

exports.deleteUser = function(data, context, admin) {
  const users = admin.firestore().collection("users");
  users.doc(data.body.userName).delete()
  .then(docRef => {
    console.log("User deleted with ID: ", docRef.id);
    context.status(200).send("User deleted successfully");
    return;
  }).catch(error => {
    console.error("Error deleting user: ", error);
    context.status(400).send("Unable to delete user");
  });
};

module.exports = exports;