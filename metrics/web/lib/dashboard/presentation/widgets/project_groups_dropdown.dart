import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/dropdown_menu.dart';
import 'package:metrics/common/presentation/constants/duration_constants.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:metrics/dashboard/presentation/view_models/project_group_dropdown_item_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/project_group_dropdown_item.dart';
import 'package:metrics/dashboard/presentation/widgets/project_group_dropdown_menu.dart';
import 'package:provider/provider.dart';

/// A dropdown widget providing an ability to select a project group.
class ProjectGroupsDropdown extends StatelessWidget {
  static const double _menuButtonHeight = 48.0;

  @override
  Widget build(BuildContext context) {
    return Selector<ProjectMetricsNotifier,
        List<ProjectGroupDropdownItemViewModel>>(
      selector: (_, notifier) => notifier.projectGroupDropdownItems,
      builder: (_, items, __) {
        return DropdownMenu<ProjectGroupDropdownItemViewModel>(
          menuAnimationCurve: Curves.linear,
          menuAnimationDuration: DurationConstants.animation,
          itemHeight: 40.0,
          initiallySelectedItemIndex: 0,
          items: items,
          menuPadding: const EdgeInsets.only(top: _menuButtonHeight),
          menuBuilder: (data) {
            return ProjectGroupDropdownMenu(data: data);
          },
          itemBuilder: (_, item) {
            return ProjectGroupDropdownItem(
              projectGroupDropdownItemViewModel: item,
            );
          },
          buttonBuilder: (_, item) => Container(
            height: _menuButtonHeight,
            width: 212.0,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(item?.name ?? ''),
                Image.network(
                  "icons/dropdown.svg",
                  height: 20.0,
                  width: 20.0,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
