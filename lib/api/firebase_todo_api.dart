import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseTodoAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  //for adding a todo
  Future<String> addTodo(Map<String, dynamic> todo) async {
    try {
      final docRef = await db.collection("todos").add(todo);
      await db.collection("todos").doc(docRef.id).update({'id': docRef.id});

      return "Successfully added todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  //to get all the todos
  Stream<QuerySnapshot> getAllTodos() {
    return db.collection("todos").snapshots();
  }

  //for deleting a todo
  Future<String> deleteTodo(String? id) async {
    try {
      await db.collection("todos").doc(id).delete();

      return "Successfully deleted todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  //for editing a todo
  Future<String> editTodo(String? id, String title, String desc, String deadine,
      String? editedBy, String? lastModified) async {
    try {
      print("New String: $title");
      await db.collection("todos").doc(id).update({
        "title": title,
        'description': desc,
        'deadline': deadine,
        'lastEditName': editedBy,
        'lastModified': lastModified
      });

      return "Successfully edited todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  //for changing the status of a todo
  Future<String> toggleStatus(String? id, bool status) async {
    try {
      await db.collection("todos").doc(id).update({"completed": status});

      return "Successfully edited todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}
