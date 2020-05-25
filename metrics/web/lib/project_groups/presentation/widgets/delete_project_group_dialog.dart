import 'package:flutter/material.dart';

class DeleteProjectGroupDialog extends StatefulWidget {
  @override
  _DeleteProjectGroupDialogState createState() =>
      _DeleteProjectGroupDialogState();
}

class _DeleteProjectGroupDialogState extends State<DeleteProjectGroupDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete group'),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FlatButton(
          onPressed: () {
            print('deleted');
            Navigator.of(context).pop();
          },
          child: const Text('Ok'),
        )
      ],
    );
  }
}
