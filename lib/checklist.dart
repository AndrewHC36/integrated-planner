import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duration/duration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as api;
import 'package:integrated_planner/task_item.dart';

import 'calendar_list.dart';
import 'modify_task.dart';

class Checklist extends StatefulWidget {
  const Checklist({Key? key, required this.uid, required this.db, required this.calendar}) : super(key: key);

  final String uid;
  final FirebaseFirestore db;
  final api.CalendarApi calendar;

  @override
  State<Checklist> createState() => _ChecklistState();
}

class _ChecklistState extends State<Checklist> {
  late final CollectionReference fsCollection;
  api.CalendarListEntry? selectedCalendar;

  final List<TaskItem> tasks = <TaskItem>[
    // TaskItem(0, "Task A", DateTime(2022, 7, 4, 4, 50), EndMethod.duration, null, Duration()),
    // TaskItem(3, "Task B", DateTime(2022, 7, 4, 4, 50), EndMethod.endTime, DateTime(2022, 7, 4, 4, 50), null),
    // TaskItem(5, "Task C", DateTime(2022, 7, 4, 4, 50), EndMethod.duration, null, Duration()),
    // TaskItem(6, "Task D", DateTime(2022, 7, 4, 4, 50), EndMethod.endTime, DateTime(2022, 7, 4, 4, 50), null),
    // TaskItem(10, "Task E", DateTime(2022, 7, 4, 4, 50), EndMethod.duration, null, Duration()),
  ];

  final List<TaskItem> deletedTasks = <TaskItem>[];  // for records
  final List<TaskItem> completedTasks = <TaskItem>[];  // for records

  @override
  void initState() {
    super.initState();

    fsCollection = widget.db.collection(widget.uid);

    widget.calendar.calendarList.list().then((value) async {
      setState(() {
        selectedCalendar = value.items![0];
      });

      var doc = await fsCollection.doc("%%meta").get();
      if(!doc.exists) {
        fsCollection
            .doc("%%meta")
            .set({"counter": 0})
            .then((value) {
          print("Successfully initialized meta document!");
        })
            .onError((error, stackTrace) {
          print("Failed to initialize meta document.");
        });
      } else {
        print("Counter num: [${doc.get("counter")}]");
      }

      _refreshTaskLists();
    }).onError((error, stackTrace) {
      print("Error: cannot get the list of calendar for the user");
    });

  }

  void _refreshTaskLists() async {
    // refreshes task list (useful whe changing calendar)
    tasks.clear();

    QuerySnapshot snapshot = await fsCollection.get();
    setState(() {
      for (var doc in snapshot.docs) {
        if(!doc.id.startsWith("%%")) {
          // no magic docs
          if(doc.get("calendarId") == selectedCalendar!.id && !(doc.get("completed") || doc.get("deleted"))) {
            // documents with correct calendar and is not completed or deleted
            log(doc.get("duration"));
            EndMethod endMethod = doc.get("endTime") == null ? EndMethod.duration : EndMethod.endTime;
            tasks.add(TaskItem(int.parse(doc.id), doc.get("taskName"), doc.get("startTime").toDate(), endMethod, doc.get("endTime")?.toDate(), parseTime(doc.get("duration"))));
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checklist: ${selectedCalendar?.summary ?? "loading..."}"),
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
                  onDismissed: (DismissDirection direction) {
                    setState(() {
                      TaskItem task = tasks.removeAt(index);
                      if(direction == DismissDirection.endToStart) {
                        // Completed Tasks
                        fsCollection
                            .doc(task.id.toString())
                            .update({"completed": true}).then((value) {
                          print("Successfully set task <${task.name}> as completed!");
                        }).onError((error, stackTrace) {
                          print("Failed to set task <${task.name}> as completed.");
                        });
                      } else {
                        // Deleted Tasks
                        fsCollection
                            .doc(task.id.toString())
                            .update({"deleted": true}).then((value) {
                          print("Successfully set task <${task.name}> as deleted!");
                        }).onError((error, stackTrace) {
                          print("Failed to set task <${task.name}> as deleted.");
                        });
                      }
                    });
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: const Icon(Icons.cancel_outlined),
                      padding: EdgeInsets.all(10.0),
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.green,
                    alignment: Alignment.centerRight,
                    child: Container(
                      child: const Icon(Icons.check_circle_outline),
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
                                  // --- modifying tasks ---

                                  final TaskItem? taskItem = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => ModifyTask(
                                          id: tasks[index].id,
                                          initTaskItem: tasks[index],
                                        ),
                                      )
                                  );

                                  if(taskItem != null) {
                                    // modifying task item to be updated in Firestore
                                    fsCollection
                                        .doc(taskItem.id.toString())
                                        .update({
                                      "taskName": taskItem.name,
                                      "startTime": taskItem.startTime,
                                      "endTime": taskItem.endTime,
                                      "duration": taskItem.duration.toString(),
                                    }).then((value) {
                                      print("Successfully updated task <${taskItem.name}>!");
                                    }).onError((error, stackTrace) {
                                      print("Failed to update task <${taskItem.name}>.");
                                    });
                                    
                                    fsCollection.doc(taskItem.id.toString())
                                        .get()
                                        .then((taskValue) async {
                                          // modifying task item in Google Calendar
                                          String eventId = taskValue.get("eventId");

                                          api.Event taskEvent = await widget.calendar.events.get(selectedCalendar!.id!, eventId);

                                          var start = api.EventDateTime();
                                          start.timeZone = selectedCalendar!.timeZone!;
                                          start.dateTime = taskItem.startTime;
                                          var end = api.EventDateTime();
                                          end.timeZone = selectedCalendar!.timeZone!;
                                          if(taskItem.endMethod == EndMethod.endTime) {
                                            end.dateTime = taskItem.endTime;
                                          } else {
                                            end.dateTime = taskItem.startTime.add(taskItem.duration!);
                                          }

                                          taskEvent.summary = taskItem.name;
                                          taskEvent.start = start;
                                          taskEvent.end = end;

                                          widget.calendar.events.update(taskEvent, selectedCalendar!.id!, eventId);
                                          print("Successfully modified task <${taskItem.name}>!");
                                    }).onError((error, stackTrace) {
                                      print("Failed modify task <${taskItem.name}>.");
                                    });



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
        ],
      ),
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton.extended(
              heroTag: "calendarButton",
              onPressed: () async {
                log(await widget.calendar.calendarList.list().toString());
                var calendarList = await widget.calendar.calendarList.list();

                var calendar = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => CalendarListView(calendars: calendarList.items!,))
                );
                setState(() {
                  selectedCalendar = calendar;
                });
                _refreshTaskLists();
              },
              label: const Text("Calendar"),
              icon: const Icon(Icons.calendar_month),
              backgroundColor: Colors.orange,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              heroTag: "taskButton",
              onPressed: () async {
                // --- adding new tasks ---

                // loads the id counter
                int id = (await fsCollection.doc("%%meta").get()).get("counter");

                final TaskItem? taskItem = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => ModifyTask(id: id,))
                );

                if(taskItem != null) {
                  // adding task item to user's Google Calendar

                  api.Event event = api.Event();

                  var start = api.EventDateTime();
                  start.timeZone = selectedCalendar!.timeZone!;
                  start.dateTime = taskItem.startTime;
                  var end = api.EventDateTime();
                  end.timeZone = selectedCalendar!.timeZone!;
                  if(taskItem.endMethod == EndMethod.endTime) {
                    end.dateTime = taskItem.endTime;
                  } else {
                    end.dateTime = taskItem.startTime.add(taskItem.duration!);
                  }

                  event.summary = taskItem.name;
                  event.start = start;
                  event.end = end;

                  widget.calendar.events.insert(event, selectedCalendar!.id!).then((eventValue) {
                    if (eventValue.status == "confirmed") {
                      log('Event added in google calendar');
                    } else {
                      log("Unable to add event in google calendar");
                    }

                    // recording task item to Firestore
                    fsCollection
                        .doc(taskItem.id.toString())
                        .set({
                      "taskName": taskItem.name,
                      "startTime": taskItem.startTime,
                      "endTime": taskItem.endTime,
                      "duration": taskItem.duration.toString(),
                      "calendarId": selectedCalendar!.id,
                      "deleted": false,
                      "completed": false,
                      "eventId": eventValue.id!,
                    }).then((value) {
                      print("Successfully added task <${taskItem.name}>!");
                    }).onError((error, stackTrace) {
                      print("Failed to add task <${taskItem.name}>.");
                    });

                    // updates and increments the id
                    fsCollection
                        .doc("%%meta")
                        .update({"counter": id+1})
                        .then((value) {
                      print("ID counter successfully incremented [${id+1}]!");
                    })
                        .onError((error, stackTrace) {
                      print("ID failed to be incremented.");
                    });
                  });

                  setState(() {
                    tasks.add(taskItem);
                  });
                }
              },
              child: const Icon(Icons.add),
              backgroundColor: Colors.lightGreen,
            ),
          ),
        ]
      ),
    );
  }
}
