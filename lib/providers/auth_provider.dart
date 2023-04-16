import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/api/firebase_auth_api.dart';

class AuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  User? userObj;

  AuthProvider() {
    authService = FirebaseAuthAPI();
    authService.getUser().listen((User? newUser) {
      userObj = newUser;
      notifyListeners();
    }, onError: (e) {
      // print a more useful error
      // print('AuthProvider - FirebaseAuth - onAuthStateChanged - $e');
    });
  }

  User? get user => userObj;

  //getter to know if user is authenticated
  bool get isAuthenticated {
    return user != null;
  }

  //get the email of the user
  String? getEmail() {
    return user?.email;
  }

  //get the display name of the user
  String? getName() {
    return user?.displayName;
  }

  //sign in
  Future<String> signIn(String email, String password) {
    return authService.signIn(email, password);
  }

  //sign out
  void signOut() {
    authService.signOut();
  }

  //sign up
  Future<String> signUp(String fname, String lname, String birthdate,
      String location, String email, String username, String password) {
    return authService.signUp(
        fname, lname, birthdate, location, email, username, password);
  }
}
