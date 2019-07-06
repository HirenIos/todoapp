import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

Future<String> initDeleteDb() async {
  final String databasePath = await getDatabasesPath();
  // print(databasePath);
  final String path = join(databasePath, 'toDo.db');
  
  // make sure the folder exists
  if (await Directory(dirname(path)).exists()) {
   // await deleteDatabase(path);
  } else {
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (e) {
      print(e);
    }
  }
  return path;
}
 Future<Database> createMyDb() async  {
     final String databasePath = await getDatabasesPath();

  return openDatabase(
  // Set the path to the database. 
  join(databasePath, 'toDo.db'),
  // When the database is first created, create a table to store dogs.
  onCreate: (db, version) {
    // Run the CREATE TABLE statement on the database.
    return db.execute(
      "CREATE TABLE todolist(id INTEGER PRIMARY KEY, name TEXT, createdAt TEXT,description TEXT,isComplete INTEGER)",
    );
  },
  // Set the version. This executes the onCreate function and provides a
  // path to perform database upgrades and downgrades.
  version: 1,
);
 }




