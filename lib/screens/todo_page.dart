import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_aranton/models/todo_model.dart';
import 'package:project_aranton/providers/todo_provider.dart';
import 'package:project_aranton/screens/modal_todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_aranton/models/user_model.dart';
import 'package:project_aranton/providers/auth_provider.dart';
import 'package:intl/intl.dart';

class TodoPage extends StatefulWidget {
  final Stream friendsStream;
  final friendsSnapshot;
  final Stream todosStream;
  final todosSnapshot;
  const TodoPage(this.friendsStream, this.friendsSnapshot, this.todosStream,
      this.todosSnapshot,
      {super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 224, 197, 171),
      body: ListView.builder(
        itemCount: widget.friendsSnapshot.data?.docs.length,
        itemBuilder: ((context, index) {
          List<String> friendsEmail = [];
          List<Widget> tasksList = [];
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
                if (friendsEmail.contains(todo.userEmail)) {
                  //friend's todo
                  tasksList.add(
                    ListTile(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: Text(todo.title),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(todo.description),
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      Text('By: ${todo.author}'),
                                      Text(
                                          'Status : ${todo.completed == true ? "Completed" : "In-progress"}'),
                                      Text(
                                          'Deadline: ${DateFormat.yMMMMEEEEd().format(DateFormat('yyyy-MM-dd').parse(todo.deadline))}'),
                                      Text(
                                          'Last edited by: ${todo.lastEditName}'),
                                      Text(
                                          'Last modified: ${todo.lastModified}')
                                    ],
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Close"),
                                      style: TextButton.styleFrom(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                      ),
                                    ),
                                  ],
                                ));
                      },
                      title: Text(todo.title),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              context
                                  .read<TodoListProvider>()
                                  .changeSelectedTodo(todo);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => TodoModal(
                                  type: 'Edit',
                                ),
                              );
                            },
                            icon: const Icon(Icons.create_outlined),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (todo.userEmail ==
                    context.read<AuthProvider>().getEmail()) {
                  tasksList.add(Dismissible(
                    key: Key(todo.id.toString()),
                    onDismissed: (direction) {
                      context.read<TodoListProvider>().changeSelectedTodo(todo);
                      context.read<TodoListProvider>().deleteTodo();

                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${todo.title} dismissed')));
                    },
                    background: Container(
                      color: Colors.red,
                      child: const Icon(Icons.delete),
                    ),
                    child: ListTile(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: Text(todo.title),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(todo.description),
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      Text('By: ${todo.author}'),
                                      Text(
                                          'Status : ${todo.completed == true ? "Completed" : "In-progress"}'),
                                      Text(
                                          'Deadline: ${DateFormat.yMMMMEEEEd().format(DateFormat('yyyy-MM-dd').parse(todo.deadline))}'),
                                      Text(
                                          'Last edited by: ${todo.lastEditName}'),
                                      Text(
                                          'Last modified: ${todo.lastModified}')
                                    ],
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Close"),
                                      style: TextButton.styleFrom(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                      ),
                                    ),
                                  ],
                                ));
                      },
                      title: Text(todo.title),
                      leading: Checkbox(
                        value: todo.completed,
                        onChanged: (bool? value) {
                          context
                              .read<TodoListProvider>()
                              .changeSelectedTodo(todo);
                          context.read<TodoListProvider>().toggleStatus(value!);
                        },
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              context
                                  .read<TodoListProvider>()
                                  .changeSelectedTodo(todo);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => TodoModal(
                                  type: 'Edit',
                                ),
                              );
                            },
                            icon: const Icon(Icons.create_outlined),
                          ),
                          IconButton(
                            onPressed: () {
                              context
                                  .read<TodoListProvider>()
                                  .changeSelectedTodo(todo);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => TodoModal(
                                  type: 'Delete',
                                ),
                              );
                            },
                            icon: const Icon(Icons.delete_outlined),
                          )
                        ],
                      ),
                    ),
                  ));
                }
              }
            }
            return Column(children: tasksList);
          }
          return Container();
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => TodoModal(
              type: 'Add',
            ),
          );
        },
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}
