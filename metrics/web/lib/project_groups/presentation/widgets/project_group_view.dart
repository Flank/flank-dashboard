import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/loading_placeholder.dart';
import 'package:metrics/common/presentation/text_placeholder/widgets/text_placeholder.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/widgets/add_project_group_card.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_card.dart';
import 'package:provider/provider.dart';

/// A widget that displays the project groups.
class ProjectGroupView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectGroupsNotifier>(
      builder: (_, projectsGroupsNotifier, __) {
        if (projectsGroupsNotifier.projectGroupsErrorMessage != null) {
          return Center(
            child: TextPlaceholder(
              text: projectsGroupsNotifier.projectGroupsErrorMessage,
            ),
          );
        }

        final projectGroupCardViewModels =
            projectsGroupsNotifier.projectGroupCardViewModels;

        if (projectGroupCardViewModels == null) {
          return const LoadingPlaceholder();
        }

        return Wrap(
          spacing: 20.0,
          runSpacing: 20.0,
          children: <Widget>[
            AddProjectGroupCard(),
            for (final projectGroup in projectGroupCardViewModels)
              ProjectGroupCard(projectGroupCardViewModel: projectGroup),
          ],
        );
      },
    );
  }
}
