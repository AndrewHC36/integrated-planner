class TaskItem {
  final int id;
  final String name;
  final String startTime; // Time format: yyyy-MM-dd HH:mm
  final EndMethod endMethod;
  final String? endTime; // Time format: yyyy-MM-dd HH:mm
  final Duration? duration;

  TaskItem(this.id, this.name, this.startTime, this.endMethod, this.endTime, this.duration);
}

enum EndMethod {
  endTime,
  duration,
}
