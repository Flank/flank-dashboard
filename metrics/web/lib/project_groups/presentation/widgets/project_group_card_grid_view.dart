import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/widgets/loading_placeholder.dart';
import 'package:metrics/common/presentation/widgets/metrics_text_placeholder.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/widgets/add_project_group_card.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_card.dart';
import 'package:provider/provider.dart';

/// A widget that displays the grid view with the list of [ProjectGroupCard].
class ProjectGroupCardGridView extends StatefulWidget {
  @override
  _ProjectGroupCardGridViewState createState() =>
      _ProjectGroupCardGridViewState();
}

class _ProjectGroupCardGridViewState extends State<ProjectGroupCardGridView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectGroupsNotifier>(
      builder: (_, projectsGroupsNotifier, __) {
        if (projectsGroupsNotifier.errorMessage != null) {
          return MetricsTextPlaceholder(
            text: CommonStrings.unknownErrorMessage,
          );
        }

        final projectGroupCardViewModels =
            projectsGroupsNotifier.projectGroupCardViewModels;

        if (projectGroupCardViewModels == null) {
          return const LoadingPlaceholder();
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 2.0,
          ),
          itemCount: projectGroupCardViewModels.length + 1,
          itemBuilder: (context, index) {
            if (index == projectGroupCardViewModels.length) {
              return AddProjectGroupCard();
            }
            return ProjectGroupCard(
              projectGroupCardViewModel: projectGroupCardViewModels[index],
            );
          },
        );
      },
    );
  }
}
