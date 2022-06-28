import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:smart_select/smart_select.dart';


class ModifyTask extends StatefulWidget {
  ModifyTask({Key? key, this.taskName}) : super(key: key);

  final String? taskName;

  @override
  State<ModifyTask> createState() => _ModifyTaskState();
}

class _ModifyTaskState extends State<ModifyTask> {
  final format = DateFormat("yyyy-MM-dd HH:mm");
  Duration _duration = Duration(hours: 0, minutes: 0);
  String value = 'flutter';
  List<S2Choice<String>> options = [
    S2Choice<String>(value: 'endt', title: 'End Time'),
    S2Choice<String>(value: 'durt', title: 'Duration'),
  ];

  final _formKeyAdd = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adding & Modifying Task"),
      ),
      body: Column(
        children: [
          Form(
            key: _formKeyAdd,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'Task Name',
                  ),
                  validator: (String? value) {
                    return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
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
                ),
                SmartSelect<String>.single(
                  title: 'End time or duration',
                  value: value,
                  choiceItems: options,
                  onChange: (state) => setState(() => value = state.value),
                ),
                DateTimeField(
                  format: format,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today),
                    labelText: 'End Time',
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
                ),
                const Text("Duration:"),
                DurationPicker(
                  duration: _duration,
                  onChange: (val) {
                  setState(() => _duration = val);
                  },
                  snapToMins: 5.0,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
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
    );
  }
}
