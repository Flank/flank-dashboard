import 'package:flutter/material.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/widgets/add_project_group_dialog.dart';
import 'package:metrics/project_groups/presentation/widgets/components/card_container.dart';

class AddProjectGroupCard extends StatelessWidget {
  final Color color = Colors.grey[600];

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: InkWell(
        onTap: () async {
          await showDialog(
            context: context,
            child: AddProjectGroupDialog(),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.add,
              size: 72.0,
              color: color,
            ),
            Text(
              ProjectGroupsStrings.addProjectGroup,
              style: TextStyle(
                fontSize: 24.0,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
