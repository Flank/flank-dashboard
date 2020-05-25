import 'package:flutter/material.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';

class DeleteProjectGroupDialog extends StatefulWidget {
  @override
  _DeleteProjectGroupDialogState createState() =>
      _DeleteProjectGroupDialogState();
}

class _DeleteProjectGroupDialogState extends State<DeleteProjectGroupDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete group'),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        FlatButton(
          onPressed: () {
            print('deleted');
            Navigator.of(context).pop();
          },
          child: Text('Ok'),
        )
      ],
    );
  }
}
