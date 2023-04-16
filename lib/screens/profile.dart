import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_aranton/providers/auth_provider.dart';
import '../providers/friends_provider.dart';
import 'package:project_aranton/models/user_model.dart';
import 'package:intl/intl.dart';

class Profile extends StatefulWidget {
  final Stream friendsStream;
  final dynamic snapshot;
  final dynamic user;
  final TextEditingController _bioController = TextEditingController();
  Profile(this.friendsStream, this.snapshot, this.user, {super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.snapshot.data?.docs.length,
      itemBuilder: ((context, index) {
        User user = User.fromJson(
            widget.snapshot.data?.docs[index].data() as Map<String, dynamic>);
        if (user.email == widget.user) {
          //if it is the correct user
          if (user.email == context.read<AuthProvider>().getEmail()) {
            //if it is the logged in user, bio can be edited
            return SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_circle_sharp,
                  size: 250,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "ID: ${user.id!}",
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    user.name,
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Birthdate: ${DateFormat.yMMMMd().format(DateFormat('yyyy-MM-dd').parse(user.birthdate))}",
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Location: ${user.location}",
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        Expanded(
                            child: Center(
                                child: Text(
                          "Bio: ${user.bio}",
                          style: const TextStyle(fontSize: 20),
                        ))),
                        SizedBox(width: 20),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: Text("Bio"),
                                      content: SingleChildScrollView(
                                          child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: widget._bioController
                                              ..text = user.bio!,
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: null,

                                            decoration: const InputDecoration(
                                              hintText: "Enter Bio",
                                            ),
                                            // onChanged: (value) {
                                            //   print(widget._bioController.text);
                                            // },
                                          ),
                                        ],
                                      )),
                                      actions: <Widget>[
                                        TextButton(
                                            onPressed: () {
                                              context
                                                  .read<FriendsListProvider>()
                                                  .editBio(
                                                      user,
                                                      widget
                                                          ._bioController.text);
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Save")),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Cancel"),
                                          style: TextButton.styleFrom(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          ),
                                        ),
                                      ],
                                    ));
                          },
                        ),
                      ])),
                ),
              ],
            ));
          } else {
            //user is not the logged in user
            return Column(
              children: [
                const Icon(
                  Icons.account_circle_sharp,
                  size: 250,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "ID: ${user.id!}",
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    user.name,
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Birthdate: ${DateFormat.yMMMMd().format(DateFormat('yyyy-MM-dd').parse(user.birthdate))}",
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Location: ${user.location}",
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Bio: ${user.bio}",
                          style: const TextStyle(fontSize: 20),
                        ),
                      ]),
                ),
              ],
            );
          }
        }
        return Container();
      }),
    );
  }
}
