import 'dart:convert';

class Task {
  Task({required this.title, this.description = "", required this.date});

  Task.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        date = DateTime.parse(json['date']),
        description = '';

  String title;
  DateTime date;
  String description;

  Map<String, dynamic> toJson() {
    return {'title': title, 'date': date.toIso8601String()};
  }
}
