import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_aranton/models/user_model.dart';
import 'package:project_aranton/providers/friends_provider.dart';
import '/screens/friend_profile.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project_aranton/providers/auth_provider.dart';

//for the friends' tab
class FriendsPage extends StatefulWidget {
  final Stream friendsStream;
  final dynamic snapshot;
  const FriendsPage(this.friendsStream, this.snapshot, {super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.snapshot.data?.docs.length,
      itemBuilder: ((context, index) {
        User user = User.fromJson(
            widget.snapshot.data?.docs[index].data() as Map<String, dynamic>);
        if (user.email == context.read<AuthProvider>().getEmail()) {
          //if the user is the currently logged in
          List<Widget> friendsWidgets =
              []; //list if widgets that would be reflected
          friendsWidgets.add(
              const SizedBox(height: 20)); //add a sizebox for space formatting
          friendsWidgets.add(const Text(
            "Friends",
            style: TextStyle(
                fontSize: 25, color: Color.fromARGB(255, 142, 142, 144)),
          ));
          if (user.friendslist.length == 0) {
            //if there is no friends yet
            friendsWidgets
                .add(const Text("No friends yet!")); //add a text widget
          } else {
            for (int i = 0; i < widget.snapshot.data?.docs.length; i++) {
              //loop through the documents
              User friend = User.fromJson(
                  widget.snapshot.data?.docs[i].data() as Map<String, dynamic>);
              if (user.friendslist.contains(friend.id)) {
                //if it is a friend of user
                friendsWidgets.add(const SizedBox(height: 10));
                friendsWidgets.add(friendWidget(user, friend, context,
                    widget.friendsStream, widget.snapshot));
              }
            }
          }

          friendsWidgets.add(const SizedBox(height: 20)); //for spacing
          friendsWidgets.add(const Text(
            "Friend Requests",
            style: TextStyle(
                fontSize: 25, color: Color.fromARGB(255, 142, 142, 144)),
          ));
          if (user.receivedFriendRequests.length == 0) {
            //if there is no friend requests
            friendsWidgets.add(const Text("No friend requests!"));
          } else {
            for (int j = 0; j < widget.snapshot.data?.docs.length; j++) {
              User fReq = User.fromJson(
                  widget.snapshot.data?.docs[j].data() as Map<String, dynamic>);
              if (user.receivedFriendRequests.contains(fReq.id)) {
                friendsWidgets.add(const SizedBox(
                  height: 10,
                ));
                friendsWidgets.add(friendReq(user, fReq, context));
              }
            }
          }
          return Column(
              children:
                  friendsWidgets); //return a column with the children being the list of widgets
        }
        return Container();
      }),
    );
  }
}

//function that returns a widget for a friend
Widget friendWidget(User user, User friend, BuildContext context,
    dynamic friendsStream, dynamic snapshot) {
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: InkWell(
              onTap: () {
                Navigator.of(context).push(PageTransition(
                    opaque: true,
                    type: PageTransitionType.bottomToTop,
                    child: FriendProfile(friendsStream, snapshot,
                        friend.username, friend.email)));
              },
              child:
                  Text(friend.username, style: const TextStyle(fontSize: 20))),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 30.0),
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(150, 121, 105, 100),
              ),
              onPressed: () {
                //if button is clicked, unfiend the person
                context.read<FriendsListProvider>().selectUser(friend);
                context.read<FriendsListProvider>().unfriend(user);
              },
              child: const Text("Unfriend")),
        )
      ],
    ),
  );
}

//function that returns a widget for a friend request
Widget friendReq(User user, User fReq, BuildContext context) {
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Text(fReq.username, style: const TextStyle(fontSize: 20)),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(150, 121, 105, 100),
              ),
              onPressed: () {
                //actions for accept
                context.read<FriendsListProvider>().selectUser(fReq);
                context.read<FriendsListProvider>().acceptFriendReq(user);
              },
              child: const Text("Accept")),
          const SizedBox(
            width: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(150, 121, 105, 100),
                ),
                onPressed: () {
                  //actions for reject
                  context.read<FriendsListProvider>().selectUser(fReq);
                  context.read<FriendsListProvider>().rejectFriendReq(user);
                },
                child: const Text("Reject")),
          )
        ])
      ],
    ),
  );
}
