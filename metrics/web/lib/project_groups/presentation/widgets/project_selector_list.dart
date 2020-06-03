import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/widgets/loading_placeholder.dart';
import 'package:metrics/common/presentation/widgets/metrics_text_placeholder.dart';
import 'package:metrics/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/widgets/project_selector_list_tile.dart';
import 'package:provider/provider.dart';

class ProjectSelectorList extends StatelessWidget {
  @override
  Widget build(BuildContext buildContext) {
    return Consumer<ProjectGroupsNotifier>(
      builder: (_, projectGroupsNotifier, __) {
        if (projectGroupsNotifier.projectsErrorMessage != null) {
          return MetricsTextPlaceholder(
            text: projectGroupsNotifier.projectsErrorMessage,
          );
        }

        final projectSelectorViewModels =
            projectGroupsNotifier.activeProjectGroupDialogViewModel.projectSelectorViewModels;

        if (projectSelectorViewModels == null) {
          return const LoadingPlaceholder();
        }

        if (projectSelectorViewModels.isEmpty) {
          return const MetricsTextPlaceholder(
            text: DashboardStrings.noConfiguredProjects,
          );
        }

        return ListView.builder(
          itemCount: projectSelectorViewModels.length,
          itemBuilder: (context, index) {
            final projectSelectorViewModel = projectSelectorViewModels[index];

            return ProjectSelectorListTile(
              projectSelectorViewModel: projectSelectorViewModel,
            );
          },
        );
      },
    );
  }
}
