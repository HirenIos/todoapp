import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:sqflite/sqflite.dart';

import 'package:provider/provider.dart';
import 'ToDoModel.dart';
import 'DataBase.dart';

class ToDoProvider with ChangeNotifier{
  StreamController<List<ToDo>> streamController = new StreamController();

  List<ToDo> arrTodo = [];
  Database database ;
  ToDoProvider()    {
       createDb();
        notifyListeners();
  }

  createDb() async {
       
    await initDeleteDb();
    database = await createMyDb();
    arrTodo = await ToDo.getTodos(database);
    streamController.add(arrTodo);
    
  }

  getDta() async{
    arrTodo = await ToDo.getTodos(database);
    streamController.add(arrTodo);
  }
}


