import 'dart:convert';
//import 'dart:js_interop';

import 'package:flutter_application_proto_ii/models/api_response.dart';
import 'package:flutter_application_proto_ii/models/task.dart';
import 'package:http/http.dart' as http;

class TaskServices {


  static Uri api_get_all_tasks = Uri.parse('http://0.0.0.0:8080/get-all-tasks');

  static Uri api_get_task = Uri.parse('http://0.0.0.0:8080/get-task');

  static Uri api_delete_task = Uri.parse('http://0.0.0.0:8080/delete-task');

  static Uri api_create_task = Uri.parse('http://0.0.0.0:8080/create-update-task');

  static const bodyTask = {"id": '657bc900e40eda1708c8746f'};

  Future<APIResponse<List<Task>>> getTaskList() {
    return http.get(api_get_all_tasks).then((data) {
      if (data.statusCode == 200) {
        final tasks = <Task>[];
        final jsonData = data.body;

        final decoded = json.decode(jsonData);
        final tasksJson = decoded['data'];
        for (var item in tasksJson) {
          tasks.add(Task(
              taskID: item['id'],
              taskTitle: item['title'],
              taskStatus: item['status'],
              taskText: item['text']));
        }

        return APIResponse<List<Task>>(data: tasks);
      } else {
        return APIResponse<List<Task>>(
            data: <Task>[],
            error: true,
            errorMessage: 'An error occured while fetching through service');
      }
    }).catchError((_) => APIResponse<List<Task>>(
        data: <Task>[],
        error: true,
        errorMessage: 'An error occured while connecting to backend'));
  }

  Future<APIResponse<Task>> getTask(String taskId) {
    var body_ =  jsonEncode(<String, String>{
              'id': taskId,
            });
    return http
        .post(api_get_task,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: body_)
        .then((data) {
      if (data.statusCode == 200) {
        final jsonDataObj = json.decode(data.body);
        final taskJson = jsonDataObj['data'];

        final task = Task(
            taskID: taskJson['id'],
            taskTitle: taskJson['title'],
            taskStatus: taskJson['status'],
            taskText: taskJson['text']);

        return APIResponse<Task>(data: task);
      } else {
        return APIResponse<Task>(
            error: true,
            errorMessage: 'An error occured while fetching through service');
      }
    }).catchError((_) => APIResponse<Task>(
            error: true,
            errorMessage: 'An error occured while connecting to backend'));
  }

  Future<APIResponse<String>> deleteTask(String taskId) {
    var body_ =  jsonEncode(<String, String>{
              'id': taskId,
            });
    return http
        .post(api_delete_task,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: body_)
        .then((data) {
      if (data.statusCode == 200) {
        final jsonDataObj = json.decode(data.body);
        final message = jsonDataObj['message'];

        return APIResponse<String>(data: message);
      } else {
        return APIResponse<String>(
            error: true,
            errorMessage: 'An error occured while fetching through service');
      }
    }).catchError((_) => APIResponse<String>(
            error: true,
            errorMessage: 'An error occured while connecting to backend'));
  }

  Future<APIResponse<Task>> creatUpdateTask(Task task_) {
    return http
        .post(api_create_task,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: task_.toJson())
        .then((data) {
      if (data.statusCode == 200) {
        final jsonDataObj = json.decode(data.body);
        final taskJson = jsonDataObj['data'];
        // Not in use for now
        // final messageJson = jsonDataObj['message'];
        // final statusJson = jsonDataObj['status'];

        final task = Task(
            taskID: taskJson['id'],
            taskTitle: taskJson['title'],
            taskStatus: taskJson['status'],
            taskText: taskJson['text']);

        return APIResponse<Task>(data: task);
      } else {
        return APIResponse<Task>(
            error: true,
            errorMessage: 'An error occured while fetching through service');
      }
    }).catchError((_) => APIResponse<Task>(
            error: true,
            errorMessage: 'An error occured while connecting to backend'));
  }
}
