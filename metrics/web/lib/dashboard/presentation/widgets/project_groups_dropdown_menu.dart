import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/dropdown_menu.dart';
import 'package:metrics/common/presentation/metrics_theme/model/dropdown_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:metrics/dashboard/presentation/view_models/project_group_dropdown_item_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/project_groups_dropdown_body.dart';
import 'package:metrics/dashboard/presentation/widgets/project_groups_dropdown_item.dart';
import 'package:provider/provider.dart';
import 'package:selection_menu/components_configurations.dart';

/// A dropdown menu widget providing an ability to select a project group.
class ProjectGroupsDropdownMenu extends StatefulWidget {
  /// A height of the dropdown menu button.
  static const double _menuButtonHeight = 48.0;

  @override
  _ProjectGroupsDropdownMenuState createState() =>
      _ProjectGroupsDropdownMenuState();
}

class _ProjectGroupsDropdownMenuState extends State<ProjectGroupsDropdownMenu> {
  /// Indicates whether the project groups dropdown is opened or not.
  bool _isOpened = false;

  /// Indicates whether widget is hovered or not.
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = MetricsTheme.of(context).dropdownTheme;

    return Consumer<ProjectMetricsNotifier>(
      builder: (_, notifier, __) {
        final items = notifier.projectGroupDropdownItems;
        final selectedItem = notifier.selectedProjectGroupDropdownItem;

        return DropdownMenu<ProjectGroupDropdownItemViewModel>(
          itemHeight: 40.0,
          initiallySelectedItemIndex: 0,
          maxVisibleItems: 5,
          items: items,
          onItemSelected: (item) {
            Provider.of<ProjectMetricsNotifier>(context, listen: false)
                .selectProjectGroupFilter(item.id);
          },
          menuPadding: const EdgeInsets.only(
            top: ProjectGroupsDropdownMenu._menuButtonHeight,
          ),
          menuBuilder: (data) {
            if (data.menuState == MenuState.OpeningStart) {
              _isOpened = true;
            } else if (data.menuState == MenuState.ClosingStart) {
              _isOpened = false;
            }

            return ProjectGroupsDropdownBody(data: data);
          },
          itemBuilder: (_, item) {
            return ProjectGroupsDropdownItem(
              projectGroupDropdownItemViewModel: item,
            );
          },
          buttonBuilder: (_, item) {
            final backgroundColor = _getBackgroundColor(theme);
            final borderColor = _getBorderColor(theme);

            return MouseRegion(
              onEnter: (_) => _changeHover(true),
              onExit: (_) => _changeHover(false),
              child: Container(
                height: ProjectGroupsDropdownMenu._menuButtonHeight,
                width: 212.0,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          selectedItem?.name ?? '',
                          style: theme.textStyle,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 13.0,
                        horizontal: 10.0,
                      ),
                      child: Image.network(
                        "icons/dropdown.svg",
                        height: 20.0,
                        width: 20.0,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Changes [_isHovered] value to the given [value].
  void _changeHover(bool value) {
    setState(() => _isHovered = value);
  }

  /// Selects the border color from the theme corresponding to a current state.
  Color _getBorderColor(DropdownThemeData theme) {
    if (_isHovered) return theme.hoverBorderColor;

    if (_isOpened) return theme.openedButtonBorderColor;

    return theme.closedButtonBorderColor;
  }

  /// Selects the background color from the theme corresponding to a current state.
  Color _getBackgroundColor(DropdownThemeData theme) {
    if (_isHovered) return theme.hoverBackgroundColor;

    if (_isOpened) return theme.openedButtonBackgroundColor;

    return theme.closedButtonBackgroundColor;
  }
}
