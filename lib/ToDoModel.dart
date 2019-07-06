import 'package:flutter/foundation.dart';
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';


class ToDo{
  final int id;
  final String createdAt;
  final String name;
  final String description;
  final int isComplete;

  ToDo(this.id, this.createdAt, this.name, this.description, this.isComplete);
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt,
      'name': name,
      'description' : description,
      'isComplete' : isComplete
    };
  }
  Future<void> insertToDo(Database database) async {
  
  await database.insert(
    'todolist',
    this.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}
static Future<List<ToDo>> getTodos(Database database) async {
  final List<Map<String, dynamic>> maps = await database.query('todolist');

  return List.generate(maps.length, (i) {
    return ToDo(maps[i]['id'], maps[i]['createdAt'], maps[i]['name'],maps[i]['description'],maps[i]['isComplete']);
    
  });
}
Future<void> updateTodo(Database database) async {

  await database.update(
    'todolist',
    this.toMap(),
    where: "id = ?",
    whereArgs: [this.id],
  );
}
Future<void> deleteTodo(Database database) async {
  await database.delete(
    'todolist',
    where: "id = ?",
    whereArgs: [this.id],
  );
}

static Future<int> getCountoftodo(Database database) async{

  return  Sqflite.firstIntValue(await database.rawQuery('SELECT COUNT(*) FROM todolist'));

}
}