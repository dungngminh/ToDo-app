import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_hive/model/todo.dart';

class ToDoScreen extends StatefulWidget {
  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final formKey = GlobalKey<FormState>();
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
          "ToDo",
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
                tileColor: Colors.white,
                onLongPress: () async {
                  await box.deleteAt(index);
                },
                title: Text(
                  toDo.title!,
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
        onPressed: () => _displayDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  Future _displayDialog(BuildContext _) async {
    return showDialog(
      context: _,
      builder: (_) {
        return AlertDialog(
          title: Text("New TO DO"),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  validator: (value) =>
                      value != '' ? null : 'Please provide TO DO title',
                  controller: _titleController,
                  decoration: InputDecoration(hintText: 'Title'),
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(hintText: 'Description'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  print(_titleController.text);
                  print(_descriptionController.text);
                  var box = Hive.box<ToDo>("todos");
                  box.add(
                    ToDo(
                      title: _titleController.text,
                      description: _descriptionController.text,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: Text('OK'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
