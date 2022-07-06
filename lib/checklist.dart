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
  int idCounter = 20;
  final List<TaskItem> tasks = <TaskItem>[
    TaskItem(0, "Task A", "2022-07-04 04:50", EndMethod.duration, null, Duration()),
    TaskItem(3, "Task B", "2022-06-04 03:55", EndMethod.endTime, "2022-07-04 04:50", null),
    TaskItem(5, "Task C", "2022-05-04 04:45", EndMethod.duration, null, Duration()),
    TaskItem(6, "Task D", "2022-04-04 20:50", EndMethod.endTime, "2022-07-04 00:00", null),
    TaskItem(10, "Task E", "2022-03-04 12:50", EndMethod.duration, null, Duration()),
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
                                onPressed: () async {
                                  final taskItem = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => ModifyTask(
                                          id: tasks[index].id,
                                          initTaskItem: tasks[index],
                                        ),
                                      )
                                  );
                                  if(taskItem != null) {
                                    setState(() {
                                      tasks[index] = taskItem;
                                    });
                                  }
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
            onPressed: () async {
              final taskItem = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => ModifyTask(id: idCounter,))
              );
              if(taskItem != null) {
                setState(() {
                  tasks.add(taskItem);
                  idCounter++;
                });
              }
            },
            child: const Text("Add Task"),
          )
        ],
      ),
    );
  }
}


