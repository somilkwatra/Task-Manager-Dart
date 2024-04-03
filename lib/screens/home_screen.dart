import 'package:flutter/material.dart';

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
            const DrawerHeader(
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
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Checkbox(
              value: tasks[index].isCompleted,
              onChanged: (value) {
                setState(() {
                  tasks[index].isCompleted = value!;
                });
              },
            ),
            title: Text(tasks[index].name),
            subtitle: Text(
              'Date: ${tasks[index].date.year}-${tasks[index].date.month}-${tasks[index].date.day} Time: ${tasks[index].time.hour}:${tasks[index].time.minute}',
            ),
          );
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
    List<Task> completedTasks = tasks.where((task) => task.isCompleted).toList();

    // Navigate to CompletedTasksScreen and pass completed tasks
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CompletedTasksScreen(completedTasks)),
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
}

class CompletedTasksScreen extends StatelessWidget {
  final List<Task> completedTasks;

  CompletedTasksScreen(this.completedTasks);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Tasks'),
        backgroundColor: Colors.green, // Set app bar color to green
      ),
      body: ListView.builder(
        itemCount: completedTasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(completedTasks[index].name),
            subtitle: Text(
              'Date: ${completedTasks[index].date.year}-${completedTasks[index].date.month}-${completedTasks[index].date.day} Time: ${completedTasks[index].time.hour}:${completedTasks[index].time.minute}',
            ),
          );
        },
      ),
    );
  }
}

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _taskNameController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _taskNameController,
              decoration: const InputDecoration(
                labelText: 'Task Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Date: ${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  child: Text('Select Date'),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Time: ${_selectedTime.hour}:${_selectedTime.minute}',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _selectTime(context);
                  },
                  child: Text('Select Time'),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Task task = Task(
                  name: _taskNameController.text,
                  date: _selectedDate,
                  time: _selectedTime,
                );
                Navigator.pop(context, task);
              },
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate)
      setState(() {
        _selectedDate = pickedDate;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime =
        await showTimePicker(context: context, initialTime: _selectedTime);
    if (pickedTime != null && pickedTime != _selectedTime)
      setState(() {
        _selectedTime = pickedTime;
      });
  }
}

