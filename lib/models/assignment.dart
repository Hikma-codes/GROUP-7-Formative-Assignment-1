class Assignment {
  String title;
  String course;
  DateTime dueDate;
  String priority;
  bool completed;

  Assignment({
    required this.title,
    required this.course,
    required this.dueDate,
    this.priority = "Medium",
    this.completed = false,
  });
}