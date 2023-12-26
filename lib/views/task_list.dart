
import 'package:flutter/material.dart';
import 'package:flutter_application_proto_ii/models/api_response.dart';
import 'package:flutter_application_proto_ii/models/task.dart';
import 'package:flutter_application_proto_ii/services/task_services.dart';
import 'package:flutter_application_proto_ii/views/task_delete.dart';
import 'package:get_it/get_it.dart';

import 'task_edit.dart';

class TaskList extends StatefulWidget {
  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  TaskServices get service => GetIt.I<TaskServices>();

  List<Task> dummyTasks = [];

  APIResponse<List<Task>>? _apiResponseAllTask;

  bool isLoding = false;

  

  @override
  void initState() {
    // TODO: implement initState
    _fetchAllTasksApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    var taskData = _apiResponseAllTask?.data;

    return Scaffold(
      appBar: AppBar(
          title: const Text('Tasks',
              style: TextStyle(fontWeight: FontWeight.bold))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) =>  const TaskEdit( taskID: '')))
          .then((_) => _fetchAllTasksApi());
        },
        child: const Icon(Icons.add),
      ),
      body: Builder(builder: (_) {
        // Loading
        if (isLoding) {
          return const Center(child: CircularProgressIndicator());
        }
        // Null response
        if (_apiResponseAllTask == null) {
          return const Center(child: Text("No Response From API"));
        }
        // Error in response
        if (_apiResponseAllTask!.error) {
          //Double check for null
          return Center(child: Text(_apiResponseAllTask!.errorMessage));
        }
        // All good!
        return ListView.separated(
          separatorBuilder: (_, __) => const SizedBox(width: 20),
          itemBuilder: (_, index) {
            return Dismissible(
              // Swipe to delete
              key: ValueKey(taskData[index].taskID), //fix it later
              direction: DismissDirection.startToEnd,
              onDismissed: (direction) {},
              confirmDismiss: (direction) async {
                final result = await showDialog(
                    context: context, builder: (_) => TaskDelete());
                if (result == true) _deleteTasksApi(taskData[index].taskID);
                return result;
              },
              background: Container(
                padding: const EdgeInsets.only(left: 10),
                child: const Align(
                    alignment: Alignment.centerLeft,
                    child:
                        Icon(Icons.delete, color: Colors.redAccent, size: 50)),
              ),
              child: Card(
                color: theme.colorScheme.primary,
                child: ListTile(
                  title: Text(
                    taskData[index].taskTitle,
                    style: style,
                  ),
                  subtitle: Text(taskData[index].isDone()? "Done" : "Incomplete",
                      style: TextStyle(color: theme.secondaryHeaderColor)),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => 
                        TaskEdit(taskID: taskData[index].taskID)))
                        .then((_) => _fetchAllTasksApi());
                  },
                ),
              ),
            );
          },
          itemCount: taskData!.length,
        );
      }),
    );
  }

  void _fetchAllTasksApi() async {
    setState(() => isLoding = true );
    _apiResponseAllTask = await service.getTaskList();
    setState(() => isLoding = false );
  }

  void _deleteTasksApi(String id) async {
    await service.deleteTask(id);
  }
}
