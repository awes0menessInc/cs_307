exports = {};

exports.addUser = function(data, context, admin) {
  const users = admin.firestore().collection("testUsers");
  // TODO: Add uid to the corresponding doc of the users collection when a new user is added
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
  users
    .doc(data.body.userName)
    .set(user)
    .then(docRef => {
      console.log("User added with ID: ", docRef.id);
      context.status(200).send("User added successfully");
      return;
    })
    .catch(error => {
      console.error("Error adding user: ", error);
      context.status(400).send("Unable to add user");
    });
};

exports.updateUser = function(data, context, admin) {
  const users = admin.firestore().collection("testUsers");
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
  users
    .doc(data.body.userName)
    .update(user)
    .then(docRef => {
      console.log("User updated with ID: ", docRef.id);
      context.status(200).send("User updated successfully");
      return;
    })
    .catch(error => {
      console.error("Error updating user: ", error);
      context.status(400).send("Unable to update user");
    });
};

exports.updateProfile = function(data, context, admin) {
    const users = admin.firestore.collection("users");
    var user = {
      firstName: data.body.firstName,
      lastName: data.body.lastName,
      bio: data.body.bio,
      email: data.body.email,
      birthday: data.body.birthday,
      website: data.body.website
    }
    users
      .doc(data.body.email)
      .update(user)
      .then(docRef => {
        console.log("User profile updated width ID: ", docRef.id);
        context.status(200).send("User profile update successfully");
        return;
      })
      .catch((error) => {
        console.error("Error updating profile, ", error);
        context.status(400).send("Unable to update user profile");
      })
};

exports.deleteUser = function(data, context, admin) {
  const users = admin.firestore().collection("testUsers");
  users
    .doc(data.body.userName)
    .delete()
    .then(docRef => {
      console.log("User deleted with ID: ", docRef.id);
      context.status(200).send("User deleted successfully");
      return;
    })
    .catch(error => {
      console.error("Error deleting user: ", error);
      context.status(400).send("Unable to delete user");
    });
};

module.exports = exports;
