import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

class FirebaseAuthAPI {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  // final db = FakeFirebaseFirestore();
  // final auth = MockFirebaseAuth(
  //     mockUser: MockUser(
  //   isAnonymous: false,
  //   uid: 'someuid',
  //   email: 'druaranton123@gmail.com',
  //   displayName: 'Charlie',
  // ));

  Stream<User?> getUser() {
    return auth.authStateChanges();
  }

  //function to sign-in
  Future<String> signIn(String email, String password) async {
    UserCredential credential;
    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.toString();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        //possible to return something more useful than just print an error message to improve UI/UX
        return 'No user found for that email';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.code;
      }
    }
  }

  //function to sign out
  void signOut() async {
    auth.signOut();
  }

  //function to sign-up
  Future<String> signUp(String fname, String lname, String birthdate,
      String location, String email, String username, String password) async {
    UserCredential credential;
    try {
      credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        credential.user?.updateDisplayName("$fname $lname");
        saveUserToFirestore(credential.user?.uid, fname, lname, birthdate,
            location, email, username);
      }
      return credential.toString();
    } on FirebaseAuthException catch (e) {
      //possible to return something more useful than just print an error message to improve UI/UX
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that username.';
      }
    } catch (e) {
      return e.toString();
    }
    return 'default';
  }

  //function to save the info of user to firestore
  void saveUserToFirestore(String? uid, String fname, String lname,
      String birthdate, String location, String email, String username) async {
    try {
      await db.collection("users").doc(uid).set({
        'id': uid,
        'name': "$fname $lname",
        'birthdate': birthdate,
        'location': location,
        'email': email,
        'username': username,
        'bio': "",
        'friendslist': [],
        'receivedFriendRequests': [],
        'sentFriendRequests': []
      });
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }
}
