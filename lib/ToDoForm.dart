import 'package:flutter/material.dart';
import 'ToDoModel.dart';
import 'dart:async';
import 'DataBase.dart';
import 'package:provider/provider.dart';
import 'DataProvider.dart';

class ToDoForm extends StatefulWidget {
  ToDoForm({Key key, this.objTodo, this.fromUpdate}) : super(key: key);
  final ToDo objTodo;
  final bool fromUpdate;

  _ToDoFormState createState() => _ToDoFormState();
}

class _ToDoFormState extends State<ToDoForm> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  var buttonTitile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buttonTitile = widget.fromUpdate == true ? "Update" : "Add";
    if (widget.objTodo != null) {
      nameController.text = widget.objTodo.name;
      descriptionController.text = widget.objTodo.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add ToDo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: nameController,
            ),
            TextField(
              controller: descriptionController,
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              onPressed: () async {
                var providerTodo = Provider.of<ToDoProvider>(context);

                DateTime now = DateTime.now();
                int values = await ToDo.getCountoftodo(providerTodo.database);
                print(values);
                if (widget.fromUpdate) {
                  var objNewTodo = ToDo(
                      widget.objTodo.id,
                      widget.objTodo.createdAt,
                      nameController.text,
                      descriptionController.text,
                      widget.objTodo.isComplete);

                  objNewTodo.updateTodo(providerTodo.database);
                } else {
                  var objTodo = ToDo(values + 1, now.toString(),
                      nameController.text, descriptionController.text, 0);

                  objTodo.insertToDo(providerTodo.database);
                }
                await providerTodo.getDta();
                Navigator.pop(context);
              },
              child: Text(buttonTitile, style: TextStyle(fontSize: 20)),
            ),
            widget.fromUpdate == true
                ? RaisedButton(
                    onPressed: () async {
                      var providerTodo = Provider.of<ToDoProvider>(context);

                      var objNewTodo = ToDo(
                          widget.objTodo.id,
                          widget.objTodo.createdAt,
                          nameController.text,
                          descriptionController.text,
                          1);
                      objNewTodo.updateTodo(providerTodo.database);
                      await providerTodo.getDta();
                      Navigator.pop(context);
                    },
                    child: Text("Complete", style: TextStyle(fontSize: 20)),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
