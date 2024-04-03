import 'package:flutter/material.dart';
import 'package:taskmanager/screens/home_screen.dart';
import 'add_task_screen.dart';

class Task {
  final String name;
  final DateTime date;
  final TimeOfDay time;
  bool isCompleted;

  Task({
    required this.name,
    required this.date,
    required this.time,
    this.isCompleted = false,
  });
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
        backgroundColor: Colors.green,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add Task'),
              onTap: () {
                _navigateToAddTaskScreen(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Completed Tasks'),
              onTap: () {
                _submitTasks();
              },
            ),
          ],
        ),
      ),




      // body: ListView.builder(
      //   itemCount: tasks.length + 1, 
      //   itemBuilder: (context, index) {
      //     if (index == tasks.length) {
           
          //   return Padding(
          //     padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          //     child: ElevatedButton(
          //       onPressed: _submitTasks,
          //       child: const Text('Submit Tasks'),
          //     ),
          //   );
          // } else {
          //   // Otherwise, display the task item
          //   return ListTile(
          //     leading: Checkbox(
          //       value: tasks[index].isCompleted,
          //       onChanged: (value) {
          //         setState(() {
          //           tasks[index].isCompleted = value!;
          //         });
          //       },




              ),
              title: Text(tasks[index].name),
              subtitle: Text(
                'Date: ${tasks[index].date.year}-${tasks[index].date.month}-${tasks[index].date.day} Time: ${tasks[index].time.hour}:${tasks[index].time.minute}',
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddTaskScreen(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _submitTasks() {
    // Get completed tasks
    List<Task> completedTasks =
        tasks.where((task) => task.isCompleted).toList();

    // Navigate to CompletedTasksScreen and pass completed tasks
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CompletedTasksScreen(completedTasks)),
    );

    // Remove completed tasks from the tasks list
    setState(() {
      tasks.removeWhere((task) => task.isCompleted);
    });
  }

  void _navigateToAddTaskScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTaskScreen()),
    );
    if (result != null) {
      setState(() {
        tasks.add(result);
      });
    }
  }
  