import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/widgets/loading_placeholder.dart';
import 'package:metrics/common/presentation/widgets/metrics_text_placeholder.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/widgets/add_project_group_card.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_card.dart';
import 'package:provider/provider.dart';

class ProjectGroupCardList extends StatefulWidget {
  @override
  _ProjectGroupCardListState createState() => _ProjectGroupCardListState();
}

class _ProjectGroupCardListState extends State<ProjectGroupCardList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectGroupsNotifier>(
      builder: (_, projectsGroupsNotifier, __) {
        if (projectsGroupsNotifier.errorMessage != null) {
          return MetricsTextPlaceholder(
            text: CommonStrings.unknownErrorMessage,
          );
        }

        final projectGroupViewModels =
            projectsGroupsNotifier.projectGroupViewModels;

        if (projectGroupViewModels == null) return const LoadingPlaceholder();

        if (projectGroupViewModels.isEmpty) {
          return MetricsTextPlaceholder(text: ProjectGroupsStrings.noProjects);
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 2.0,
          ),
          itemCount: projectGroupViewModels.length + 1,
          itemBuilder: (context, index) {
            if (index == projectGroupViewModels.length) {
              return AddProjectGroupCard();
            }

            final projectGroupViewModel = projectGroupViewModels[index];

            return ProjectGroupCard(
              projectGroupViewModel: projectGroupViewModel,
            );
          },
        );
      },
    );
  }
}
