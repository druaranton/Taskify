import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_aranton/models/todo_model.dart';
import 'package:project_aranton/providers/todo_provider.dart';
import 'package:project_aranton/screens/modal_todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_aranton/models/user_model.dart';
import 'package:project_aranton/providers/auth_provider.dart';
import 'package:intl/intl.dart';
import 'package:dart_date/dart_date.dart';

class NotificationPage extends StatefulWidget {
  final Stream friendsStream;
  final friendsSnapshot;
  final Stream todosStream;
  final todosSnapshot;
  const NotificationPage(this.friendsStream, this.friendsSnapshot,
      this.todosStream, this.todosSnapshot,
      {super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 224, 197, 171),
      body: ListView.builder(
        itemCount: widget.friendsSnapshot.data?.docs.length,
        itemBuilder: ((context, index) {
          List<String> friendsEmail = [];
          List<Widget> notifsList = [];
          User user = User.fromJson(widget.friendsSnapshot.data?.docs[index]
              .data() as Map<String, dynamic>);
          if (user.email == context.read<AuthProvider>().getEmail()) {
            for (int i = 0; i < widget.friendsSnapshot.data?.docs.length; i++) {
              User otherUser = User.fromJson(
                  widget.friendsSnapshot.data?.docs[i].data()
                      as Map<String, dynamic>);
              if (user.friendslist.contains(otherUser.id)) {
                friendsEmail.add(otherUser.email);
              }
            }

            dynamic numTodos = widget.todosSnapshot.data?.docs.length;

            for (int j = 0; j < numTodos; j++) {
              Todo todo = Todo.fromJson(widget.todosSnapshot.data?.docs[j]
                  .data() as Map<String, dynamic>);

              if (friendsEmail.contains(todo.userEmail) ||
                  todo.userEmail == context.read<AuthProvider>().getEmail()) {
                var deadlineDate =
                    DateFormat('yyyy-MM-dd').parse(todo.deadline);
                if (deadlineDate.isSameDay(DateTime.now())) {
                  notifsList.add(Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.notifications_active_outlined),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Task ${todo.title} is due today!",
                              style: const TextStyle(fontSize: 20)),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      )
                    ],
                  ));
                  notifsList.add(const SizedBox(
                    height: 20,
                  ));
                }
              }
            }
            return Column(children: notifsList);
          }
          return Container();
        }),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {

      //   },
      //   child: const Icon(Icons.remove),
      // ),
    );
  }
}
