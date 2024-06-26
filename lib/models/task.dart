class Task {
  Task({required this.title, this.description = "", required this.date}) {}

  String title;
  DateTime date;
  String? description;
}
