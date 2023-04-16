/*
  Created by: Claizel Coubeili Cepe
  Date: 27 October 2022
  Description: Sample todo app with networking
*/

import 'package:flutter/material.dart';
import 'package:project_aranton/api/firebase_todo_api.dart';
// import 'package:project_aranton/api/firebase_todo_api.dart';
import 'package:project_aranton/models/todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoListProvider with ChangeNotifier {
  late FirebaseTodoAPI firebaseService;
  late Stream<QuerySnapshot> _todosStream;
  Todo? _selectedTodo;

  TodoListProvider() {
    firebaseService = FirebaseTodoAPI();
    fetchTodos();
  }

  // getter
  Stream<QuerySnapshot> get todos => _todosStream;
  Todo get selected => _selectedTodo!;

  changeSelectedTodo(Todo item) {
    _selectedTodo = item;
  }

  //get all todos provider
  void fetchTodos() {
    _todosStream = firebaseService.getAllTodos();
    notifyListeners();
  }

  //add todo provider
  void addTodo(Todo item) async {
    String message = await firebaseService.addTodo(item.toJson(item));
    print(item.toJson(item));
    print(message);
    notifyListeners();
  }

  //edit todo provider
  void editTodo(String newTitle, String desc, String deadine, String? editedBy,
      String? lastModified) async {
    String message = await firebaseService.editTodo(
        _selectedTodo!.id, newTitle, desc, deadine, editedBy, lastModified);
    print(message);
    notifyListeners();
  }

  //delete todo provider
  void deleteTodo() async {
    String message = await firebaseService.deleteTodo(_selectedTodo!.id);
    print(message);
    notifyListeners();
  }

  //change status provider
  void toggleStatus(bool status) async {
    String message =
        await firebaseService.toggleStatus(_selectedTodo!.id, status);
    print(message);
    notifyListeners();
  }
}
