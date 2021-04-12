import 'package:flutter/material.dart';
import 'package:sqflite_pro/screens/TodoList.dart';
import 'package:sqflite_pro/helpers/dbmanager.dart';

class SQLitePage extends StatefulWidget {
  @override
  _SQLitePageState createState() => _SQLitePageState();
}

class _SQLitePageState extends State<SQLitePage> {
  final DbStudentManager dbmanager = new DbStudentManager();

  final _nameController = TextEditingController();
  final _courseController = TextEditingController();
  final _presenceController = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  final List<String> _priorities = ['Yes', 'No'];

  Student student;
  List<Student> studlist;

  int updateIndex;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 35, left: 30),
                child: Text('Diary',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                        fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 35,
                  right: 20,
                  left: 190,
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TodoListScreeen()));
                  },
                  child: Icon(
                    Icons.arrow_right,
                    size: 70,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 5, left: 5, top: 10),
                        child: TextFormField(
                          decoration: new InputDecoration(
                              labelText: 'Name',
                              labelStyle: TextStyle(fontSize: 18),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          controller: _nameController,
                          validator: (val) => val.isNotEmpty
                              ? null
                              : 'Name Should Not Be empty',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 5, left: 5, top: 10),
                        child: TextFormField(
                          decoration: new InputDecoration(
                              labelText: 'Course',
                              labelStyle: TextStyle(fontSize: 18),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          controller: _courseController,
                          validator: (val) => val.isNotEmpty
                              ? null
                              : 'Course Should Not Be empty',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                          padding:
                              const EdgeInsets.only(right: 5, left: 5, top: 10),
                          child: DropdownButtonFormField(
                            isDense: true,
                            items: _priorities.map((String presence) {
                              return DropdownMenuItem(
                                  value: presence,
                                  child: Text(
                                    presence,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  ));
                            }).toList(),
                            style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                                labelText: 'Presence',
                                labelStyle: TextStyle(fontSize: 18),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            validator: (input) => _presenceController == null
                                ? "Please Select a priority level"
                                : null,
                            onChanged: (value) {
                              setState(() {
                                _presenceController.text = value;
                              });
                            },
                          )),
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 10, left: 10, top: 30),
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          textColor: Colors.white,
                          color: Colors.green,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30)),
                              width: width,
                              child: Text(
                                'Submit',
                                textAlign: TextAlign.center,
                              )),
                          onPressed: () {
                            _submitStudent(context);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FutureBuilder(
                        future: dbmanager.getStudentList(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            studlist = snapshot.data;
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: studlist == null ? 0 : studlist.length,
                              itemBuilder: (BuildContext context, int index) {
                                Student st = studlist[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  child: Card(
                                    elevation: 3,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(left: 13),
                                          width: width * 0.63,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'Name: ${st.name}',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              Text(
                                                'Course: ${st.course}',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                'Presence: ${st.presence}',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            _nameController.text = st.name;
                                            _courseController.text = st.course;
                                            _presenceController.text =
                                                st.presence;
                                            student = st;
                                            updateIndex = index;
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            dbmanager.deleteStudent(st.id);
                                            setState(() {
                                              studlist.removeAt(index);
                                            });
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          return new CircularProgressIndicator();
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitStudent(BuildContext context) {
    if (_formKey.currentState.validate()) {
      if (student == null) {
        Student st = new Student(
          name: _nameController.text,
          course: _courseController.text,
          presence: _presenceController.text,
        );
        dbmanager.insertStudent(st).then((id) => {
              _nameController.clear(),
              _courseController.clear(),
              _presenceController.clear(),
              print('Student Added to Db ${id}')
            });
      } else {
        student.name = _nameController.text;
        student.course = _courseController.text;
        student.presence = _presenceController.text;

        dbmanager.updateStudent(student).then((id) => {
              setState(() {
                studlist[updateIndex].name = _nameController.text;
                studlist[updateIndex].course = _courseController.text;
                studlist[updateIndex].presence = _presenceController.text;
              }),
              _nameController.clear(),
              _courseController.clear(),
              _presenceController.clear(),
              student = null
            });
      }
    }
  }
}
