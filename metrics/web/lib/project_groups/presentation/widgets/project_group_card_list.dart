import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/widgets/loading_placeholder.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
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
          return const Center(
            child: Text('ERROR MESSAGE'),
          );
        }

        final projectGroupViewModels =
            projectsGroupsNotifier.projectGroupViewModels;

        if (projectGroupViewModels == null) return const LoadingPlaceholder();

        if (projectGroupViewModels.isEmpty) {
          // return const _DashboardTablePlaceholder(
          //   text: ProjectGroupsStrings.noConfiguredProjectGroups,
          // );
          return const Center(child: Text('PROJECT GROUPS EMPTY'));
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 2.0,
          ),
          itemCount: projectGroupViewModels.length,
          itemBuilder: (context, index) {
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
