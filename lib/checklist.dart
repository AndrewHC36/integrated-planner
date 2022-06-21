import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add_task.dart';

class Checklist extends StatefulWidget {
  const Checklist({Key? key}) : super(key: key);

  @override
  State<Checklist> createState() => _ChecklistState();
}

class _ChecklistState extends State<Checklist> {
  final List<int> taskID = <int>[0, 1, 2, 4, 6];
  final List<String> taskNames = <String>['A', 'B', 'C', 'D', 'E'];

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
              itemCount: taskNames.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  key: ValueKey(taskID[index]),
                  // tileColor: Colors.black12,
                  title: Container(
                    height: 50,
                    color: Colors.black12,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Text('Entry ${taskNames[index]}'),
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                          ),
                        ),
                        Container(
                          child: IconButton(
                              icon: Icon(Icons.menu),
                              onPressed: () {  }
                          ),
                          color: Colors.blue,
                        ),
                        Container(
                          child: IconButton(
                            icon: Icon(Icons.cancel_outlined),
                            onPressed: () {  },
                          ),
                          color: Colors.red,
                        ),
                      ],
                    ),
                    // margin: const EdgeInsets.symmetric(vertical: 1.0),
                  ),
                );
              },
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final int elTid = taskID.removeAt(oldIndex);
                  final String elTnm = taskNames.removeAt(oldIndex);
                  taskID.insert(newIndex, elTid);
                  taskNames.insert(newIndex, elTnm);
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => AddTask())
              );
            },
            child: const Text("Add Task"),
          )
        ],
      ),
    );
  }
}

/*
ListView.builder(
        itemCount: entries.length+1,
        itemBuilder: (BuildContext context, int index) {
          if (index != entries.length) {
            return Container(
              height: 50,
              color: Colors.black12,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: Text('Entry ${entries[index]}'),
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                    ),
                  ),
                  Container(
                    child: IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () {  }
                    ),
                    color: Colors.blue,
                  ),
                  Container(
                    child: IconButton(
                      icon: Icon(Icons.cancel_outlined),
                      onPressed: () {  },
                    ),
                    color: Colors.red,
                  ),
                ],
              ),
              margin: const EdgeInsets.symmetric(vertical: 1.0),
            );
          } else {  // if last one
            return ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => AddTask())
                );
              },
              child: const Text("Add Task"),
            );
          }
        }
        )
 */

/*
// Container(
                  //   height: 50,
                  //   color: Colors.black12,
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: Container(
                  //           child: Text('Entry ${entries[index]}'),
                  //           padding: EdgeInsets.symmetric(horizontal: 10.0),
                  //         ),
                  //       ),
                  //       Container(
                  //         child: IconButton(
                  //             icon: Icon(Icons.menu),
                  //             onPressed: () {  }
                  //         ),
                  //         color: Colors.blue,
                  //       ),
                  //       Container(
                  //         child: IconButton(
                  //           icon: Icon(Icons.cancel_outlined),
                  //           onPressed: () {  },
                  //         ),
                  //         color: Colors.red,
                  //       ),
                  //     ],
                  //   ),
                  //   margin: const EdgeInsets.symmetric(vertical: 1.0),
                  // ),
 */