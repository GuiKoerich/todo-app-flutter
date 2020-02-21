import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io';

void main() {
  runApp(MaterialApp(
    title: 'ToDo App',
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _toDoController = TextEditingController(); 

  List _toDo_list = [];

  @override
  void initState() {
    super.initState();

    _readData().then((data) {
      setState(() {
        this._toDo_list = json.decode(data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo App'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _toDoController,
                    decoration: InputDecoration(
                      labelText: 'Nova tarefa',
                      labelStyle: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: _addToDo, 
                  color: Colors.blueAccent,
                  child: Text('ADD'),
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10.0),
              itemCount: _toDo_list.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(_toDo_list[index]['title']),
                  value: _toDo_list[index]['done'],
                  secondary: CircleAvatar(
                    child: Icon(_toDo_list[index]['done'] ? Icons.check : Icons.error),
                  ),
                  onChanged: (mark) {
                    setState(() {
                      _toDo_list[index]['done'] = mark;
                      _saveData();
                    });
                  },

                );
              }
            ),
          ),
        ],
      ),
    );
  }

  void _addToDo() {
    setState(() {
      Map<String, dynamic> newToDo = Map();

      newToDo['title'] = this._toDoController.text;
      newToDo['done'] = false;
      this._toDoController.text = '';

      this._toDo_list.add(newToDo);

      _saveData();
    });
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();

    return File('${directory.path}/data.json');
  }

  Future<File> _saveData() async {
    String data = json.encode(this._toDo_list);

    final file = await _getFile();

    return file.writeAsString(data);
  } 

  Future<String> _readData() async {
    try {
      final file = await _getFile();

      return file.readAsString();

    } catch (e) {
      return null;

    }
  }
}