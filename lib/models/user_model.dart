import 'dart:convert';

//user class
class User {
  //fields
  String? id;
  String name;
  String birthdate;
  String location;
  String email;
  String username;
  String? bio;
  List<dynamic> friendslist;
  List<dynamic> receivedFriendRequests;
  List<dynamic> sentFriendRequests;

  //constructor
  User(
      {this.id,
      required this.name,
      required this.birthdate,
      required this.location,
      required this.email,
      required this.username,
      required this.bio,
      required this.friendslist,
      required this.receivedFriendRequests,
      required this.sentFriendRequests});

  // Factory constructor to instantiate object from json format
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        name: json['name'],
        birthdate: json['birthdate'],
        location: json['location'],
        email: json['email'],
        username: json['username'],
        bio: json['bio'],
        friendslist: json['friendslist'],
        receivedFriendRequests: json['receivedFriendRequests'],
        sentFriendRequests: json['sentFriendRequests']);
  }

  static List<User> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<User>((dynamic d) => User.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(User user) {
    return {
      'id': user.id,
      'name': user.name,
      'birthdate': user.birthdate,
      'location': user.location,
      'email': user.email,
      'username': user.username,
      'bio': user.bio,
      'fiendslist': user.friendslist,
      'receivedFriendRequests': user.receivedFriendRequests,
      'sentFriendRequests': user.sentFriendRequests,
    };
  }
}
