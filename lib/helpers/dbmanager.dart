import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbStudentManager {
  // БД
  Database _database;

  // Создание базы данных
  Future openDb() async {
    if (_database == null) {
      _database = await openDatabase(
          join(await getDatabasesPath(), "people.db"),
          version: 3, onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE people(id INTEGER PRIMARY KEY autoincrement, name TEXT, course TEXT, presence TEXT)",
        );
      });
    }
  }

  // Вставка
  Future<int> insertStudent(Student student) async {
    await openDb();
    return await _database.insert('people', student.toMap());
  }

  // Получение коллекций студентов
  Future<List<Student>> getStudentList() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.query('people');
    return List.generate(maps.length, (i) {
      return Student(
          id: maps[i]['id'],
          name: maps[i]['name'],
          course: maps[i]['course'],
          presence: maps[i]['presence']);
    });
  }

  // Обновление
  Future<int> updateStudent(Student student) async {
    await openDb();
    return await _database.update('people', student.toMap(),
        where: "id = ?", whereArgs: [student.id]);
  }

  // Удаление
  Future<void> deleteStudent(int id) async {
    await openDb();
    await _database.delete('people', where: "id = ?", whereArgs: [id]);
  }
}

class Student {
  int id;
  String name;
  String course;
  String presence;
  Student({
    @required this.name,
    @required this.course,
    @required this.presence,
    this.id,
  });

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['name'] = name;
    map['course'] = course;
    map['presence'] = presence;
    return map;
  }
}
