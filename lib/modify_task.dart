import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:integrated_planner/task_item.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'number_text_field.dart';


class ModifyTask extends StatefulWidget {
  ModifyTask({Key? key, required this.id, this.initTaskItem}) : super(key: key);

  final int id;
  final TaskItem? initTaskItem;

  @override
  State<ModifyTask> createState() => _ModifyTaskState();
}

class _ModifyTaskState extends State<ModifyTask> {
  final modifyFormKey = GlobalKey<FormState>();

  final format = DateFormat("yyyy-MM-dd HH:mm:ss");
  late final TextEditingController taskNameController;
  late final TextEditingController startTimeController;  // time in format of this.format
  late EndMethod endMethod;
  late String endMethodValue;
  late final TextEditingController endTimeController;  // time in format of this.format
  late final TextEditingController daysController;
  late final TextEditingController hoursController;
  late final TextEditingController minutesController;

  @override
  void initState() {
    super.initState();
    taskNameController = TextEditingController(text: widget.initTaskItem?.name ?? "");
    startTimeController = TextEditingController(text: widget.initTaskItem?.startTime == null ? " " : format.format(widget.initTaskItem!.startTime));
    endMethod = widget.initTaskItem?.endMethod ?? EndMethod.endTime;
    endMethodValue = endMethod == EndMethod.endTime ? "endt" : "durt";
    endTimeController = TextEditingController(text: widget.initTaskItem?.endTime == null ? " " : format.format(widget.initTaskItem!.endTime!));
    daysController = TextEditingController(text: (widget.initTaskItem?.duration?.inDays ?? 0).toString());
    hoursController = TextEditingController(text: ((widget.initTaskItem?.duration?.inHours ?? 0) % 24).toString());
    minutesController = TextEditingController(text: ((widget.initTaskItem?.duration?.inMinutes ?? 0) % 60).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adding & Modifying Task"),
      ),
      body: Form(
        key: modifyFormKey,
        child: Column(
          children: [
            TextFormField(
              controller: taskNameController,
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Task Name',
              ),
              validator: (String? value) {
                return value == null || value.isEmpty ? "Field required" : null;
              },
            ),
            DateTimeField(
              controller: startTimeController,
              format: format,
              decoration: const InputDecoration(
                icon: Icon(Icons.calendar_today),
                labelText: 'Start Time',
              ),
              onShowPicker: (context, currentValue) async {
                final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100));
                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime:
                    TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                  );
                  return DateTimeField.combine(date, time);
                } else {
                  return currentValue;
                }
              },
              validator: (DateTime? date) {
                return startTimeController.text.isEmpty ? "Field required" : null;
              },
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.timelapse)
                    ),
                    value: endMethodValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        endMethodValue = newValue!;
                        if(endMethodValue == "endt") {
                          endMethod = EndMethod.endTime;
                        } else {
                          endMethod = EndMethod.duration;
                        }
                      });
                    },
                    items: const [
                      DropdownMenuItem<String>(
                        value: "endt",
                        child: Text("Ending Time"),
                      ),
                      DropdownMenuItem<String>(
                        value: "durt",
                        child: Text("Duration"),
                      ),
                    ],
                    validator: (String? value) {
                      return value == null ? "Field Required" : null;
                    },
                  ),
                ),
              ],
            ),
            Visibility(
              child: DateTimeField(
                controller: endTimeController,
                format: format,
                decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_today),
                  labelText: 'Final Time',
                ),
                onShowPicker: (context, currentValue) async {
                  final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100));
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime:
                      TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                    );
                    return DateTimeField.combine(date, time);
                  } else {
                    return currentValue;
                  }
                },
                validator: (DateTime? _date) {
                  return endTimeController.text.isEmpty && endMethod == EndMethod.endTime ? "Field required" : null;
                },
              ),
              visible: endMethod == EndMethod.endTime,
            ),
            Visibility(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: NumberTextField(
                        icon: const Icon(Icons.timelapse),
                        labelText: "Day",
                        controller: daysController,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 3.0),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: NumberTextField(
                        labelText: "Hour",
                        controller: hoursController,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 3.0),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: NumberTextField(
                        labelText: "Minute",
                        controller: minutesController,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 3.0),
                    ),
                  ),
                ],
              ),
              visible: endMethod == EndMethod.duration,
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if(modifyFormKey.currentState!.validate()) {
                      Duration duration = Duration(
                        days: int.parse(daysController.text),
                        hours: int.parse(hoursController.text),
                        minutes: int.parse(minutesController.text),
                      );

                      if(duration == const Duration()) {
                        duration = const Duration(minutes: 1);
                      }
                      log(endTimeController.text);
                      Navigator.pop(
                        context,
                        TaskItem(
                          widget.id,
                          taskNameController.text,
                          DateTime.parse(startTimeController.text),
                          endMethod,
                          endTimeController.text.trim() != "" ? DateTime.parse(endTimeController.text) : null,
                          duration,
                        ),  // TODO: add a mechanism for ID counter
                      );
                    }
                  },
                  child: const Text("OK"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
