// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/loading_placeholder.dart';
import 'package:metrics/common/presentation/text_placeholder/widgets/text_placeholder.dart';
import 'package:metrics/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/widgets/project_checkbox_list_tile.dart';
import 'package:provider/provider.dart';

/// The widget that displays a list of [ProjectCheckboxListTile]
/// for project selection.
class ProjectCheckboxList extends StatelessWidget {
  @override
  Widget build(BuildContext buildContext) {
    const placeholderPadding = EdgeInsets.only(top: 16.0);

    return Consumer<ProjectGroupsNotifier>(
      builder: (_, projectGroupsNotifier, __) {
        if (projectGroupsNotifier.projectsErrorMessage != null) {
          return Padding(
            padding: placeholderPadding,
            child: TextPlaceholder(
              text: projectGroupsNotifier.projectsErrorMessage,
            ),
          );
        }

        final projectCheckboxViewModels =
            projectGroupsNotifier.projectCheckboxViewModels;

        if (projectCheckboxViewModels == null) {
          return const LoadingPlaceholder();
        }

        if (projectCheckboxViewModels.isEmpty) {
          return Padding(
            padding: placeholderPadding,
            child: TextPlaceholder(
              text: projectGroupsNotifier.projectNameFilter == null
                  ? DashboardStrings.noConfiguredProjects
                  : ProjectGroupsStrings.noSearchResults,
            ),
          );
        }

        return Material(
          type: MaterialType.transparency,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 24.0),
            itemCount: projectCheckboxViewModels.length,
            itemBuilder: (context, index) {
              final projectCheckboxViewModel = projectCheckboxViewModels[index];

              return ProjectCheckboxListTile(
                projectCheckboxViewModel: projectCheckboxViewModel,
              );
            },
          ),
        );
      },
    );
  }
}
