import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:metrics/common/presentation/widgets/metrics_button_card.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_dialog.dart';
import 'package:provider/provider.dart';

/// An [AddProjectGroupCard] widget that represent a button card.
class AddProjectGroupCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MetricsButtonCard(
      backgroundColor:
          themeNotifier.isDark ? Colors.grey[900] : Colors.grey[200],
      iconData: Icons.add,
      iconSize: 72.0,
      iconPadding: const EdgeInsets.symmetric(vertical: 4.0),
      titlePadding: const EdgeInsets.symmetric(vertical: 4.0),
      title: Text(
        ProjectGroupsStrings.addProjectGroup,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        maxLines: 1,
        style: const TextStyle(fontSize: 24.0),
      ),
      onTap: () async {
        Provider.of<ProjectGroupsNotifier>(context, listen: false)
            .generateActiveProjectGroupViewModel();
        await showDialog(
          context: context,
          child: ProjectGroupDialog(),
        );
      },
    );
  }
}
