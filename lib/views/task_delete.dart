import 'package:flutter/material.dart';


class TaskDelete extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Warning'),
      content: const Text('Are you sure you want to delete this task?'),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Yes'),
          onPressed: () {
            //Call Api
            //_deleteTasksApi(context;
            Navigator.of(context).pop(true);
          },
        ),
        ElevatedButton(
          child: const Text('No'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ],
    );
  }
}