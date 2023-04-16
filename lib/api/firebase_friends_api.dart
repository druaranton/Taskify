import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

class FirebaseFriendsAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  // final db = FakeFirebaseFirestore();

  //stream
  Stream<QuerySnapshot> getAllFriends() {
    return db.collection("users").snapshots();
  }

  //for unfriending
  Future<String> unfriend(String? userid, String? toUnfriendid) async {
    try {
      await db.collection("users").doc(userid).update({
        "friendslist": FieldValue.arrayRemove([toUnfriendid])
      });
      await db.collection("users").doc(toUnfriendid).update({
        "friendslist": FieldValue.arrayRemove([userid])
      });
      return "Successfully unfriended!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  //for adding friend
  Future<String> addFriend(String? userid, String? toAddId) async {
    try {
      await db.collection("users").doc(userid).update({
        "sentFriendRequests": FieldValue.arrayUnion([toAddId])
      });
      await db.collection("users").doc(toAddId).update({
        "receivedFriendRequests": FieldValue.arrayUnion([userid])
      });
      return "Successfully added user!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  //for accepting friend request
  Future<String> acceptFriendReq(String? userid, String? requestorId) async {
    try {
      await db.collection("users").doc(userid).update({
        "friendslist": FieldValue.arrayUnion([requestorId])
      });
      await db.collection("users").doc(userid).update({
        "receivedFriendRequests": FieldValue.arrayRemove([requestorId])
      });
      await db.collection("users").doc(requestorId).update({
        "friendslist": FieldValue.arrayUnion([userid])
      });
      await db.collection("users").doc(requestorId).update({
        "sentFriendRequests": FieldValue.arrayRemove([userid])
      });
      return "Successfully accepted friend request!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  //for rejectin friend request
  Future<String> rejectFriendReq(String? userid, String? requestorId) async {
    try {
      await db.collection("users").doc(userid).update({
        "receivedFriendRequests": FieldValue.arrayRemove([requestorId])
      });
      await db.collection("users").doc(requestorId).update({
        "sentFriendRequests": FieldValue.arrayRemove([userid])
      });
      return "Successfully rejected friend request!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  //for ediiting the bio of the user
  Future<String> editBio(String? userid, String? bio) async {
    try {
      await db.collection("users").doc(userid).update({"bio": bio});
      return "Sucessfully edited bio";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}
