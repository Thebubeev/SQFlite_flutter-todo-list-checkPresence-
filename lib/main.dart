import 'package:flutter/material.dart';
import 'package:sqflite_pro/screens/TodoList.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: TodoListScreeen(),
    );
  }
}
