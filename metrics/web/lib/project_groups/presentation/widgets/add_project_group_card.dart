import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';
import 'package:metrics/common/presentation/metrics_theme/model/add_project_group_card/attention_level/add_project_group_card_attention_level.dart';
import 'package:metrics/common/presentation/metrics_theme/model/add_project_group_card/style/add_project_group_card_style.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/widgets/metrics_card.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/widgets/add_project_group_dialog.dart';
import 'package:provider/provider.dart';

/// An [AddProjectGroupCard] widget that displays a button card.
class AddProjectGroupCard extends StatelessWidget {
  /// Creates a new [AddProjectGroupCard] instance.
  const AddProjectGroupCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<ProjectGroupsNotifier, bool>(
      selector: (_, notifier) => notifier.hasConfiguredProjects,
      builder: (context, hasConfiguredProjects, _) {
        final attentionLevel =
            MetricsTheme.of(context).addProjectGroupCardTheme.attentionLevel;

        final style = _getStyle(
          attentionLevel: attentionLevel,
          hasConfiguredProjects: hasConfiguredProjects,
        );

        final asset =
            hasConfiguredProjects ? 'icons/add.svg' : 'icons/disabled-add.svg';

        return TappableArea(
          onTap: hasConfiguredProjects
              ? () => _showProjectGroupDialog(context)
              : null,
          cursor: "pointer",
          builder: (bool isHovered) {
            return MetricsCard(
              decoration: BoxDecoration(
                color: isHovered ? style.hoverColor : style.backgroundColor,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.network(
                    asset,
                    width: 32.0,
                    height: 32.0,
                    color: style.iconColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      ProjectGroupsStrings.createGroup,
                      style: style.labelStyle,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Selects the proper style from the [attentionLevel] depending on [hasConfiguredProjects].
  AddProjectGroupCardStyle _getStyle({
    AddProjectGroupCardAttentionLevel attentionLevel,
    bool hasConfiguredProjects,
  }) {
    return hasConfiguredProjects
        ? attentionLevel.positive
        : attentionLevel.inactive;
  }

  /// Shows a [AddProjectGroupDialog] with an active project group.
  Future<void> _showProjectGroupDialog(BuildContext context) async {
    final projectGroupsNotifier = Provider.of<ProjectGroupsNotifier>(
      context,
      listen: false,
    );

    projectGroupsNotifier.initProjectGroupDialogViewModel();

    if (projectGroupsNotifier.projectGroupDialogViewModel == null) return;

    await showDialog(
      context: context,
      child: AddProjectGroupDialog(),
    );

    projectGroupsNotifier.resetProjectGroupDialogViewModel();
  }
}
