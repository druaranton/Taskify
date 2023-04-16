import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_aranton/models/todo_model.dart';
import 'package:project_aranton/providers/todo_provider.dart';
import 'package:intl/intl.dart';
import 'package:project_aranton/providers/auth_provider.dart';
import '../services/local_notification_service.dart';

class TodoModal extends StatefulWidget {
  final String type;
  // int todoIndex;
  final TextEditingController _editTitleController = TextEditingController();
  final TextEditingController _editDescriptionController =
      TextEditingController();
  final TextEditingController _editDate = TextEditingController();
  final TextEditingController _date = TextEditingController();
  final Map<String, dynamic> addValues = {
    'title': "",
    'description': "",
    'deadline': "",
  };

  TodoModal({
    required this.type,
    super.key,
  });

  @override
  State<TodoModal> createState() => _TodoModalState();
}

class _TodoModalState extends State<TodoModal> {
  late final NotificationService service;

  @override
  void initState() {
    service = NotificationService();
    service.initializePlatformNotifications();
    // listenToNotification();
    super.initState();
  }

  Text _buildTitle() {
    switch (widget.type) {
      case 'Add':
        return const Text("Add new todo");
      case 'Edit':
        return const Text("Edit todo");
      case 'Delete':
        return const Text("Delete todo");
      default:
        return const Text("");
    }
  }

  // Method to build the content or body depending on the functionality
  Widget _buildContent(BuildContext context) {
    switch (widget.type) {
      case 'Delete':
        {
          return Text(
            "Are you sure you want to delete '${context.read<TodoListProvider>().selected.title}'?",
          );
        }
      // Edit and add will have input field in them
      case 'Add':
        {
          return SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              decoration: const InputDecoration(
                hintText: "Title",
              ),
              onChanged: ((String? value) {
                widget.addValues['title'] = value; //store in the map
              }),
            ),
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: "Description",
              ),
              onChanged: ((String? value) {
                widget.addValues['description'] = value; //store in the map
              }),
            ),
            TextFormField(
              controller: widget._date,
              decoration: const InputDecoration(
                hintText: "Deadline",
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100));
                if (pickedDate != null) {
                  setState(() {
                    widget._date.text = widget.addValues['deadline'] =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    DateFormat('yyyy-MM-dd').format(pickedDate);
                  });
                }
              },
            )
          ]));
        }
      default:
        print(context.read<AuthProvider>().getName());
        return SingleChildScrollView(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Title'),
            TextField(
              controller: widget._editTitleController
                ..text = context.read<TodoListProvider>().selected.title,
              decoration: const InputDecoration(
                hintText: "Title",
              ),
            ),
            const SizedBox(height: 10),
            const Text('Description'),
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: widget._editDescriptionController
                ..text = context.read<TodoListProvider>().selected.description,
              decoration: const InputDecoration(
                hintText: "Description",
              ),
            ),
            const SizedBox(height: 10),
            const Text('Deadline'),
            TextField(
              controller: widget._editDate
                ..text = context.read<TodoListProvider>().selected.deadline,
              decoration: const InputDecoration(
                hintText: "Deadline",
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100));
                if (pickedDate != null) {
                  widget._editDate.text =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                }
              },
            )
          ],
        ));
    }
  }

  TextButton _dialogAction(BuildContext context) {
    return TextButton(
      onPressed: () async {
        switch (widget.type) {
          case 'Add':
            {
              Todo temp = Todo(
                  userEmail: context.read<AuthProvider>().getEmail(),
                  completed: false,
                  author: context.read<AuthProvider>().getName(),
                  title: widget.addValues['title'],
                  description: widget.addValues['description'],
                  deadline: widget.addValues['deadline'],
                  lastEditName: context.read<AuthProvider>().getName(),
                  lastModified: DateFormat().format(DateTime.now()));

              context.read<TodoListProvider>().addTodo(temp);
              // Remove dialog after adding
              Navigator.of(context).pop();
              await service.showScheduledNotification(
                  title: 'A task is due today!',
                  body:
                      '${'Your task ' + widget.addValues['title']} is due today!',
                  seconds: 5,
                  date: DateTime.parse(widget.addValues['deadline']));
              break;
            }
          case 'Edit':
            {
              context.read<TodoListProvider>().editTodo(
                  widget._editTitleController.text,
                  widget._editDescriptionController.text,
                  widget._editDate.text,
                  context.read<AuthProvider>().getName(),
                  DateFormat().format(DateTime.now()));

              // Remove dialog after editing
              Navigator.of(context).pop();
              break;
            }
          case 'Delete':
            {
              context.read<TodoListProvider>().deleteTodo();

              // Remove dialog after editing
              Navigator.of(context).pop();
              break;
            }
        }
      },
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      child: Text(widget.type),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildTitle(),
      content: _buildContent(context),

      // Contains two buttons - add/edit/delete, and cancel
      actions: <Widget>[
        _dialogAction(context),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}


////
