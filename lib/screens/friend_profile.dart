import 'package:flutter/material.dart';
import '/screens/profile.dart';

//class for the friend's profile
class FriendProfile extends StatefulWidget {
  final Stream friendsStream;
  final snapshot;
  final uname;
  final dynamic user;
  const FriendProfile(this.friendsStream, this.snapshot, this.uname, this.user,
      {super.key});

  @override
  State<FriendProfile> createState() => _FriendProfileState();
}

class _FriendProfileState extends State<FriendProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 224, 197, 171),
      appBar: AppBar(
        title: Text(widget.uname), //username of the friend will be displayed
      ),
      body: Profile(widget.friendsStream, widget.snapshot,
          widget.user), //uses the profile class
    );
  }
}
