import 'dart:convert';

class Task {
  String taskID;
  String taskTitle;
  String taskStatus;
  String taskText;

  Task(
      {required this.taskID,
      required this.taskTitle,
      required this.taskStatus,
      required this.taskText});

  Map<String, dynamic> toMap() {
    return {
      "title": taskTitle,
      "text": taskText,
      "status": taskStatus,
      "id": taskID,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  bool isDone() {
    return taskStatus == "completed";
  }

  static String convertToCompleted(bool completed) {
    return completed ? "completed" : "incomplete";
  }

  // setDone(bool completed) {
  //   completed ? taskStatus == "completed" : taskStatus = "incomplete";
  // }
}
