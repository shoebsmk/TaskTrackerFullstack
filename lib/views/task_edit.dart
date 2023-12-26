import 'package:flutter/material.dart';
import 'package:flutter_application_proto_ii/models/task.dart';
import 'package:flutter_application_proto_ii/services/task_services.dart';
import 'package:get_it/get_it.dart';

class TaskEdit extends StatefulWidget {
  final String taskID;
  const TaskEdit({super.key, required this.taskID});
  //Task task;
  @override
  State<TaskEdit> createState() => _TaskEditState();
}

class _TaskEditState extends State<TaskEdit> {
  bool isChecked = false;
  bool get isEditing => widget.taskID != '';
  bool isLoding = false;

  TaskServices get service => GetIt.I<TaskServices>();

  late String errorMessage;
  late Task task;

  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (isEditing) { // save in task var
      setState(() => isLoding = true);
      service.getTask(widget.taskID).then((response) {
        if (response.error) {
          errorMessage = response.errorMessage;
        } else {
          setState(() => isLoding = false);
          task = response.data!;
          isChecked = task.isDone();
          _titleEditingController.text = task.taskTitle;
          _textEditingController.text = task.taskText;
        }
      });
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Task' : 'Create Task')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: isLoding
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  TextField(
                    controller: _titleEditingController,
                    decoration: const InputDecoration(hintText: 'Task title'),
                  ),
                  Container(height: 8),
                  TextField(
                    controller: _textEditingController,
                    decoration: const InputDecoration(hintText: 'Task content'), 
                    keyboardType: TextInputType.multiline,
                    maxLines: 20,
                  ),
                  Container(height: 16),
                  Row(children: [
                    Checkbox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                            //task.setDone(value);
                          });
                        }),
                    const Text("Completed")
                  ]),
                  Container(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 35,
                    child: ElevatedButton(
                      child: const Text('Save'),
                      //color: Theme.of(context).primaryColor,
                      onPressed: () async {
                        if (_titleEditingController.text == "") {
                          alertCustom(
                              context, "Title cannot be empty", "Try again");
                          return;
                        }

                        setState(() => isLoding = true);
                        var newTask = Task(
                            taskID: isEditing ? task.taskID : "",
                            taskTitle: _titleEditingController.text,
                            taskStatus: Task.convertToCompleted(isChecked),
                            taskText: _textEditingController.text);

                        final result = await service.creatUpdateTask(newTask);
                        setState(() => isLoding = false);

                        // Set up alert Dialog
                        var doneMessage = isEditing
                            ? "Task updated Succesfully"
                            : "Task created Succesfully";
                        var dialogContent =
                            result.error ? result.errorMessage : doneMessage;

                        // ignore: use_build_context_synchronously
                        alertCustom(context, "Done", dialogContent)
                            .then((data) => {
                                  if (result.data != null)
                                    {Navigator.of(context).pop(true)}
                                });
                      },
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Future<dynamic> alertCustom(BuildContext context, String title, String text) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Ok'),
            onPressed: () {
              //Call Api
              //_deleteTasksApi(context;
              Navigator.of(context).pop(true);
            },
          )
        ],
      ),
    );
  }

}
