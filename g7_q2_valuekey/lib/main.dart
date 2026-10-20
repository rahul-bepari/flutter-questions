import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TaskPage(),
    ));

class Task {
  final int id;
  final String title;
  Task(this.id, this.title);
}

class TaskTile extends StatefulWidget {
  final Task task;
  final VoidCallback onDelete;
  const TaskTile({super.key, required this.task, required this.onDelete});

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool done = false; // this state belongs to the State object

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: done,
        onChanged: (v) => setState(() => done = v!),
      ),
      title: Text(widget.task.title),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: widget.onDelete,
      ),
    );
  }
}

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final List<Task> tasks = [
    Task(1, 'Buy milk'),
    Task(2, 'Study Flutter'),
    Task(3, 'Call mom'),
    Task(4, 'Go for a walk'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: ListView(
        children: tasks
            .map((t) => TaskTile(
                  key: ValueKey(t.id), // <-- delete this line to see the bug
                  task: t,
                  onDelete: () => setState(() => tasks.remove(t)),
                ))
            .toList(),
      ),
    );
  }
}
