import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';
import 'DataProvider.dart';
import 'ToDoForm.dart';
import 'ToDoModel.dart';
import 'DataBase.dart';
import 'package:provider/provider.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(builder: (_) => ToDoProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'TO DO List'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ToDoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<List<ToDo>>(
        stream: provider.streamController.stream, // a Stream<int> or null
        builder: (BuildContext context, AsyncSnapshot<List<ToDo>> snapshot) {
          if (snapshot.data == null) {
            return Container();
          }
          return ListView.separated(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              final item = snapshot.data[index];

              return Dismissible(
                // Each Dismissible must contain a Key. Keys allow Flutter to
                // uniquely identify widgets.
                key: Key(item.id.toString()),
                // Provide a function that tells the app
                // what to do after an item has been swiped away.
                onDismissed: (direction) {
                  // Remove the item from the data source.
                  setState(() {
                    provider.arrTodo.removeAt(index);
                    item.deleteTodo(provider.database);
                  });

                  // Then show a snackbar.
                  // Scaffold.of(context)
                  //     .showSnackBar(SnackBar(content: Text("$item dismissed")));
                },
                // Show a red background as the item is swiped away.
                background: Container(color: Colors.red),
                child: ListTile(
                  title: Text(provider.arrTodo[index].name),
                  trailing: Container(
                    width: 40,
                    height: 40,
                    child: snapshot.data[index].isComplete == 1
                        ? Icon(
                            Icons.done,
                            color: Colors.green,
                          )
                        : Container(),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ToDoForm(
                              objTodo: snapshot.data[index], fromUpdate: true)),
                    );
                  },
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) => Divider(
                  color: Colors.black,
                ),
          ); // unreachable
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ToDoForm(fromUpdate: false)),
          );
        },
        tooltip: 'Add Todo',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
