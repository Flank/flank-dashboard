import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/loading_placeholder.dart';
import 'package:metrics/common/presentation/widgets/metrics_text_placeholder.dart';
import 'package:metrics/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/widgets/project_checkbox_list_tile.dart';
import 'package:provider/provider.dart';

/// The widget that displays a list of [ProjectCheckboxListTile]
/// for project selection.
class ProjectCheckboxList extends StatelessWidget {
  @override
  Widget build(BuildContext buildContext) {
    return Consumer<ProjectGroupsNotifier>(
      builder: (_, projectGroupsNotifier, __) {
        if (projectGroupsNotifier.projectsErrorMessage != null) {
          return MetricsTextPlaceholder(
            text: projectGroupsNotifier.projectsErrorMessage,
          );
        }

        final projectCheckboxViewModels =
            projectGroupsNotifier.projectCheckboxViewModels;

        if (projectCheckboxViewModels == null) {
          return const LoadingPlaceholder();
        }

        if (projectCheckboxViewModels.isEmpty) {
          return const MetricsTextPlaceholder(
            text: DashboardStrings.noConfiguredProjects,
          );
        }

        return ListView.builder(
          itemCount: projectCheckboxViewModels.length,
          itemBuilder: (context, index) {
            final projectCheckboxViewModel = projectCheckboxViewModels[index];

            return ProjectCheckboxListTile(
              projectCheckboxViewModel: projectCheckboxViewModel,
            );
          },
        );
      },
    );
  }
}
