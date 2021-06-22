import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_hive/model/todo.dart';
import 'package:todo_hive/view/add_todo.dart';

class ToDoScreen extends StatefulWidget {
  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  @override
  void dispose() {
    Hive.close(); // close all boxes
    // Hive.box("todos").close() we can use it if wanna to close 1 box instead of

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ToDo App",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<ToDo>("todos").listenable(),
        builder: (context, Box<ToDo> box, _) {
          if (box.values.isEmpty)
            return Center(
              child: Text(
                "You don't have any \"To Do\" in here ",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            );
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (_, index) {
              ToDo toDo = box.getAt(index)!;
              return ListTile(
                onLongPress: () async {
                  await box.deleteAt(index);
                },
                title: Text(
                  toDo.title ?? "",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  toDo.description ?? "",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        isExtended: true,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddTodo(),
          ),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
