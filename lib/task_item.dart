class TaskItem {
  final int id;
  final String name;
  final String startTime;
  final EndMethod endMethod;  // false: endTime, true: duration
  final String? endTime;
  final Duration? duration;

  TaskItem(this.id, this.name, this.startTime, this.endMethod, this.endTime, this.duration);
}

enum EndMethod {
  endTime,
  duration,
}
