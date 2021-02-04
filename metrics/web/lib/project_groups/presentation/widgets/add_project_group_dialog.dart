// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_dialog.dart';
import 'package:metrics/project_groups/presentation/widgets/strategy/add_project_group_dialog_strategy.dart';

/// A widget that displays a dialog with the form
/// for adding a new project group.
class AddProjectGroupDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final strategy = AddProjectGroupDialogStrategy();

    return ProjectGroupDialog(
      strategy: strategy,
    );
  }
}
