import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:integrated_planner/task_item.dart';

import 'modify_task.dart';

class Checklist extends StatefulWidget {
  const Checklist({Key? key}) : super(key: key);

  @override
  State<Checklist> createState() => _ChecklistState();
}

class _ChecklistState extends State<Checklist> {
  // final List<int> taskID = <int>[0, 1, 2, 4, 6];
  // final List<String> taskNames = <String>['Entry A', 'Entry B', 'Entry C', 'Entry D', 'Entry E'];
  final List<TaskItem> tasks = <TaskItem>[
    TaskItem(0, "Task A", "", EndMethod.duration, "", Duration()),
    TaskItem(3, "Task B", "", EndMethod.endTime, "??", null),
    TaskItem(5, "Task C", "", EndMethod.duration, "", Duration()),
    TaskItem(6, "Task D", "", EndMethod.endTime, "??", null),
    TaskItem(10, "Task E", "", EndMethod.duration, "", Duration()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text("TODO"),
            ElevatedButton(
              onPressed: () {

              },
              child: const Text("Google Calendar"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black12),
              ),
            ),
          ]
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ReorderableListView.builder(
              // padding: EdgeInsets.all(10),
              itemCount: tasks.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: ValueKey(tasks[index].id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (DismissDirection direction) {
                    setState(() {
                      tasks.removeAt(index);
                    });
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    child: Container(
                      child: const Icon(Icons.cancel_outlined),
                      padding: EdgeInsets.all(10.0),
                    ),
                  ),
                  child: ListTile(
                    key: ValueKey(tasks[index].id),
                    // tileColor: Colors.black12,
                    title: Container(
                      height: 50,
                      color: Colors.black12,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: Text(tasks[index].name),
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            ),
                          ),
                          Container(
                            child: IconButton(
                                icon: const Icon(Icons.menu),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => ModifyTask(
                                          initTaskName: tasks[index].name,
                                        ),
                                      )
                                  );
                                }
                            ),
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      // margin: const EdgeInsets.symmetric(vertical: 1.0),
                    ),
                  ),
                );
              },
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  TaskItem taskItem = tasks.removeAt(oldIndex);
                  tasks.insert(newIndex, taskItem);
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => ModifyTask())
              );
            },
            child: const Text("Add Task"),
          )
        ],
      ),
    );
  }
}


