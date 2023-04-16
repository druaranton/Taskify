/*
  Created by: Claizel Coubeili Cepe
  Date: 27 October 2022
  Description: Sample todo app with networking
*/

import 'dart:convert';

class Todo {
  String? userEmail;
  String? id;
  String? author;
  String title;
  String description;
  String deadline;
  bool completed;
  String? lastEditName;
  String? lastModified;

  Todo(
      {required this.userEmail,
      this.id,
      required this.author,
      required this.title,
      required this.description,
      required this.deadline,
      required this.completed,
      required this.lastEditName,
      required this.lastModified});

  // Factory constructor to instantiate object from json format
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
        userEmail: json['userEmail'],
        id: json['id'],
        author: json['author'],
        title: json['title'],
        description: json['description'],
        deadline: json['deadline'],
        completed: json['completed'],
        lastEditName: json['lastEditName'],
        lastModified: json['lastModified']);
  }

  static List<Todo> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Todo>((dynamic d) => Todo.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Todo todo) {
    return {
      'userEmail': todo.userEmail,
      'author': todo.author,
      'title': todo.title,
      'description': todo.description,
      'deadline': todo.deadline,
      'completed': todo.completed,
      'lastEditName': todo.lastEditName,
      'lastModified': todo.lastModified
    };
  }
}
