import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:integrated_planner/task_item.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:smart_select/smart_select.dart';


class ModifyTask extends StatefulWidget {
  ModifyTask({Key? key, this.initTaskName}) : super(key: key);

  final String? initTaskName;

  @override
  State<ModifyTask> createState() => _ModifyTaskState();
}

class _ModifyTaskState extends State<ModifyTask> {
  String endMethodChoiceValue = '';
  List<S2Choice<String>> options = [
    S2Choice<String>(value: 'endt', title: 'End Time'),
    S2Choice<String>(value: 'durt', title: 'Duration'),
  ];

  final modifyFormKey = GlobalKey<FormState>();

  final format = DateFormat("yyyy-MM-dd HH:mm");
  final taskNameController = TextEditingController();
  final startTimeController = TextEditingController();  // time in format of this.format
  EndMethod endMethod = EndMethod.endTime;
  String endMethodValue = "endt";
  final endTimeController = TextEditingController();  // time in format of this.format
  Duration duration = Duration(hours: 0, minutes: 0);

  @override
  void initState() {
    super.initState();
    taskNameController.text = widget.initTaskName ?? "";
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
                return date == null ? "Invalid datetime format" : null;
              },
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
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
            DateTimeField(
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
              validator: (DateTime? date) {
                return date == null && endMethod == EndMethod.endTime ? "Invalid datetime format" : null;
              },
            ),
            const Text("Duration:"),
            DurationPicker(
              duration: duration,
              onChange: (val) {
                setState(() => duration = val);
              },
              snapToMins: 5.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if(modifyFormKey.currentState!.validate()) {
                      Navigator.pop(
                        context,
                        TaskItem(0, taskNameController.text, startTimeController.text, endMethod, endTimeController.text, duration),  // TODO: add a mechanism for ID counter
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
