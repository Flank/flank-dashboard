import 'package:flutter/material.dart';
import 'package:metrics/dashboard/presentation/view_models/project_group_dropdown_item_view_model.dart';

/// A widget that displays a project group within a dropdown.
class ProjectGroupDropdownItem extends StatefulWidget {
  /// A [ProjectGroupDropdownItemViewModel] with project group data to display.
  final ProjectGroupDropdownItemViewModel projectGroupDropdownItemViewModel;

  /// Creates the [ProjectGroupDropdownItem]
  /// with the given [projectGroupDropdownItemViewModel].
  ///
  /// The [projectGroupDropdownItemViewModel] must not be null.
  const ProjectGroupDropdownItem({
    Key key,
    @required this.projectGroupDropdownItemViewModel,
  })  : assert(projectGroupDropdownItemViewModel != null),
        super(key: key);

  @override
  _ProjectGroupDropdownItemState createState() =>
      _ProjectGroupDropdownItemState();
}

class _ProjectGroupDropdownItemState extends State<ProjectGroupDropdownItem> {
  /// Indicates whether this widget is hovered or not.
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        _isHovered ? const Color(0xFF1d1d20) : Colors.transparent;

    return MouseRegion(
      onEnter: (_) => _changeHover(true),
      onExit: (_) => _changeHover(false),
      child: Container(
        width: 210.0,
        height: 40.0,
        color: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        alignment: Alignment.centerLeft,
        child: Text(
          widget.projectGroupDropdownItemViewModel.name,
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  /// Changes [_isHovered] value to the given [value].
  void _changeHover(bool value) {
    setState(() => _isHovered = value);
  }
}
