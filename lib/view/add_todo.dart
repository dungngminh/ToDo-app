import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_hive/model/todo.dart';

class AddTodo extends StatefulWidget {
  final formKey = GlobalKey<FormState>();

  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  _addData() async {
    if (widget.formKey.currentState!.validate()) {
      print(titleController.text);
      print(descriptionController.text);
      var box = Hive.box<ToDo>("todos");
      box.add(
        ToDo(
          title: titleController.text,
          description: descriptionController.text,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add"),
        centerTitle: true,
      ),
      body: Form(
        key: widget.formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: [
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(hintText: "Add title"),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(hintText: "Add description"),
            ),
            ElevatedButton(
              onPressed: () => _addData(),
              child: Text(
                "Add To Do",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
