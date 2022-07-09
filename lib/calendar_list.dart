import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart';


class CalendarListView extends StatefulWidget {
  const CalendarListView({Key? key, required this.calendars}) : super(key: key);

  final List<CalendarListEntry> calendars;  // calendar ID : calendar "summary"

  @override
  State<CalendarListView> createState() => _CalendarListViewState();
}

class _CalendarListViewState extends State<CalendarListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Calendars"),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: widget.calendars.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                log("tapped $index ${widget.calendars[index].summary}");

                Navigator.pop(
                  context,
                  widget.calendars[index],
                );
              },
              child: Container(
                height: 45.0,
                child: Text(
                  "${widget.calendars[index].summary}",
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
