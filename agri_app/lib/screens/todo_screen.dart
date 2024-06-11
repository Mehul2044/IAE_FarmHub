import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class ToDo {
  late bool isCompleted;
  late DateTime date;
  late String title;

  ToDo(this.isCompleted, this.date, this.title);

  // Method to convert a ToDo item to a map
  Map<String, dynamic> toJson() => {
        'isCompleted': isCompleted,
        'date': date.toIso8601String(),
        'title': title,
      };
}

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({Key? key}) : super(key: key);

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  DateTime? _selectedDate;
  String? title;
  final List<ToDo> list = [];
  bool isLoading = false;
  late DatabaseReference _todoRef;

  @override
  void initState() {
    super.initState();
    // Initialize Firebase
    // Fetch data from Realtime Database
    _todoRef = FirebaseDatabase.instance
        .ref()
        .child("todos/${FirebaseAuth.instance.currentUser!.uid}");
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final dataSnapshot = await _todoRef.get();
      final Map<dynamic, dynamic> data =
          dataSnapshot.value as Map<dynamic, dynamic>;
      list.clear();
      data.forEach((key, value) {
        final todo = ToDo(value['isCompleted'], DateTime.parse(value['date']),
            value['title']);
        list.add(todo);
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ToDo Screen")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : list.isEmpty
              ? const Center(child: Text("No ToDo Item found!"))
              : Stack(
                  children: [
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        gradient: LinearGradient(
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                          colors: [
                            Colors.white,
                            Color.fromARGB(100, 249, 228, 188),
                          ],
                          stops: [0.0, 1.0],
                        ),
                      ),
                    ),
                    ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final todo = list[index];
                        return ListTile(
                          title: Text(todo.title),
                          subtitle: Text(DateFormat.yMd().format(todo.date)),
                          leading: Checkbox(
                            checkColor: Colors.black,
                            fillColor: MaterialStateColor.resolveWith((states) {
                              if (states.contains(MaterialState.disabled)) {
                                // Color when checkbox is disabled
                                return Colors.grey.withOpacity(
                                    0.5); // Adjust opacity as needed
                              }
                              // Color when checkbox is enabled
                              return Colors.grey;
                            }),
                            value: todo.isCompleted,
                            onChanged: (value) {
                              setState(() {
                                todo.isCompleted = value!;
                              });
                              updateTodoInDatabase(todo);
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
      floatingActionButton: IconButton(
        style:
            IconButton.styleFrom(backgroundColor: Colors.grey.withOpacity(0.5)),
        onPressed: () {
          _showAddToDoModal(context);
        },
        icon: const Icon(Icons.add, size: 40),
      ),
    );
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void _showAddToDoModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Builder(
            builder: (context) => Container(
              padding: const EdgeInsets.all(20),
              height: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Title'),
                    onChanged: (value) {
                      setState(() {
                        title = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          alignment: Alignment.centerLeft,
                        ),
                        onPressed: () => {_presentDatePicker()},
                        icon: const Icon(Icons.calendar_month),
                        label: const Text("Pick a Date"),
                      ),
                      if (_selectedDate != null)
                        Text(
                          "Picked Date: ${DateFormat.yMd().format(_selectedDate!)}",
                        ),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  ElevatedButton(
                    onPressed: () {
                      // Add ToDo logic here
                      if (_selectedDate != null && title != null) {
                        final newTodo = ToDo(false, _selectedDate!, title!);
                        list.add(newTodo);
                        saveTodoInDatabase(newTodo);
                        setState(() {
                          _selectedDate = null;
                          title = null;
                        });
                      }
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.purple,
                    ),
                    child: const Text('Add Task'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> saveTodoInDatabase(ToDo todo) async {
    try {
      await _todoRef.push().set(todo.toJson());
    } catch (error) {
      print('Error saving todo: $error');
    }
  }

  Future<void> updateTodoInDatabase(ToDo todo) async {
    try {
      final dataSnapshot = await _todoRef.get();
      final Map<dynamic, dynamic> data =
          dataSnapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        if (value['title'] == todo.title) {
          _todoRef.child(key).update({
            'isCompleted': todo.isCompleted,
          });
        }
      });
    } catch (error) {
      print('Error updating todo: $error');
}
}
}