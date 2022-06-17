import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add_task.dart';

class Checklist extends StatefulWidget {
  const Checklist({Key? key}) : super(key: key);

  @override
  State<Checklist> createState() => _ChecklistState();
}

class _ChecklistState extends State<Checklist> {
  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];

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
      body: ListView.builder(
        itemCount: entries.length+1,
        itemBuilder: (BuildContext context, int index) {
          if (index != entries.length) {
            return Container(
              height: 50,
              color: Colors.amber[colorCodes[index]],
              child: Center(child: Text('Entry ${entries[index]}')),
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
    );
  }
}
