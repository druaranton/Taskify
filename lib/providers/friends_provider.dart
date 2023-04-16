import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_aranton/api/firebase_friends_api.dart';
//import 'package:week7_networking_discussion/api/todo_api.dart';
import 'package:project_aranton/models/user_model.dart';

class FriendsListProvider with ChangeNotifier {
  late FirebaseFriendsAPI firebaseService;
  late Stream<QuerySnapshot> _friendsStream;
  User? _selectedUser;

  FriendsListProvider() {
    firebaseService = FirebaseFriendsAPI();
    fetchFriends();
  }

  // getter
  Stream<QuerySnapshot> get friends => _friendsStream;
  User get selected => _selectedUser!;

  selectUser(User item) {
    _selectedUser = item;
  }

  void fetchFriends() {
    _friendsStream = firebaseService.getAllFriends();
    notifyListeners();
  }

  //unfriend provider
  void unfriend(User user) async {
    String message = await firebaseService.unfriend(user.id, _selectedUser!.id);
    print(message);
  }

  //add user provider
  void addFriend(User user) async {
    String message =
        await firebaseService.addFriend(user.id, _selectedUser!.id);
    print(message);
  }

  //accept friend request provider
  void acceptFriendReq(User user) async {
    String message =
        await firebaseService.acceptFriendReq(user.id, _selectedUser!.id);
    print(message);
  }

  //reject friend request provider
  void rejectFriendReq(User user) async {
    String message =
        await firebaseService.rejectFriendReq(user.id, _selectedUser!.id);
    print(message);
  }

  //edit bio provider
  void editBio(User user, String newbio) async {
    String message = await firebaseService.editBio(user.id, newbio);
    print(message);
  }
}
