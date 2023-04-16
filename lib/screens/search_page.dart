import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_aranton/models/user_model.dart';
import 'package:project_aranton/providers/friends_provider.dart';
import 'package:project_aranton/providers/auth_provider.dart';

class SearchPage extends StatefulWidget {
  final Stream friendsStream;
  final dynamic snapshot;
  const SearchPage(this.friendsStream, this.snapshot, {super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController editingController =
      TextEditingController(); //text controller
  String toSearch = ""; //string that would store the input of user
  @override
  Widget build(BuildContext context) {
    // return
    return Column(children: [
      const SizedBox(
        height: 10,
      ),
      TextField(
          onChanged: (value) {
            setState(() {
              toSearch = value; //update toSearch
            });
          },
          controller: editingController,
          decoration: const InputDecoration(
              labelText: "Search",
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))))),
      Expanded(
          child: ListView.builder(
              itemCount: widget.snapshot.data?.docs.length,
              itemBuilder: ((context, index) {
                User user = User.fromJson(widget.snapshot.data?.docs[index]
                    .data() as Map<String, dynamic>);
                if (user.email == context.read<AuthProvider>().getEmail()) {
                  List<Widget> searchWidgets =
                      []; //list to store widgets of results
                  searchWidgets.add(const SizedBox(
                    height: 20,
                  ));
                  RegExp toSearchRegex = RegExp(
                    '.*$toSearch.*',
                    caseSensitive: false,
                    multiLine: false,
                  ); //creates a regex

                  // if (toSearch == "") {
                  //   //if no input
                  //   return Container(); //just return a container
                  // } else {
                  for (int i = 0; i < widget.snapshot.data?.docs.length; i++) {
                    User searchResult = User.fromJson(
                        widget.snapshot.data?.docs[i].data()
                            as Map<String, dynamic>);
                    if (toSearchRegex.hasMatch(searchResult.username)) {
                      if (searchResult.username == user.username) {
                        //if searched is the user
                        searchWidgets.add(Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Text(user.username),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 30.0),
                              child: Text("Logged-in user"),
                            )
                          ],
                        ));
                        searchWidgets.add(const SizedBox(
                          height: 10,
                        ));
                      } else if (user.friendslist.contains(searchResult.id)) {
                        //if it is a friend of user
                        searchWidgets.add(Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Text(searchResult.username),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 30.0),
                              child: Text("Friends"),
                            )
                          ],
                        ));
                        searchWidgets.add(const SizedBox(
                          height: 10,
                        ));
                      } else if (user.receivedFriendRequests
                          .contains(searchResult.id)) {
                        //if it has pending request
                        searchWidgets.add(Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Text(searchResult.username),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 30.0),
                              child: Text("Pending request"),
                            )
                          ],
                        ));
                        searchWidgets.add(const SizedBox(
                          height: 10,
                        ));
                      } else if (user.sentFriendRequests
                          .contains(searchResult.id)) {
                        //if it is also pending
                        searchWidgets.add(Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Text(searchResult.username),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 30.0),
                              child: Text("Pending request"),
                            )
                          ],
                        ));
                        searchWidgets.add(const SizedBox(
                          height: 10,
                        ));
                      } else {
                        //if it is not a friend
                        searchWidgets.add(Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Text(searchResult.username),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 30.0),
                              child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: const Color.fromRGBO(
                                        150, 121, 105, 100),
                                  ),
                                  onPressed: () {
                                    context
                                        .read<FriendsListProvider>()
                                        .selectUser(searchResult);
                                    context
                                        .read<FriendsListProvider>()
                                        .addFriend(user);
                                  },
                                  child: const Text("Add friend")),
                            )
                          ],
                        ));
                        searchWidgets.add(const SizedBox(
                          height: 10,
                        ));
                      }
                    }
                  }
                  // }
                  return Column(children: searchWidgets);
                }
                return Container();
              })))
    ]);
  }
}
