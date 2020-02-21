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

  List _toDo_list = List();

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
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