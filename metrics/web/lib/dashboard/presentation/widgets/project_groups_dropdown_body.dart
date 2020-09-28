import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/dropdown_body.dart';
import 'package:metrics/common/presentation/constants/duration_constants.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:selection_menu/components_configurations.dart';

/// A widget that displays a project groups dropdown body.
class ProjectGroupsDropdownBody extends StatelessWidget {
  /// An [AnimationComponentData] that provides an information
  /// about dropdown body animation.
  final AnimationComponentData data;

  /// Creates the [ProjectGroupsDropdownBody] with the given [data].
  ///
  /// The [data] must not be `null`.
  const ProjectGroupsDropdownBody({
    Key key,
    @required this.data,
  })  : assert(data != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = MetricsTheme.of(context).dropdownTheme;

    return DropdownBody(
      state: data.menuState,
      animationDuration: DurationConstants.animation,
      maxHeight: data.constraints.maxHeight,
      maxWidth: 212.0,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(0.0, 8.0),
            blurRadius: 16.0,
            color: theme.shadowColor,
          ),
        ],
      ),
      onOpenStateChanged: _onOpenStateChanges,
      child: SizedBox(
        width: 212.0,
        child: Card(
          margin: const EdgeInsets.only(top: 4.0),
          color: theme.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          elevation: 0.0,
          child: Padding(
            key: UniqueKey(),
            padding: const EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 1.0,
            ),
            child: data.child,
          ),
        ),
      ),
    );
  }

  /// Listens to opened state changes.
  void _onOpenStateChanges(bool isOpen) {
    if (isOpen) {
      data.opened();
    } else {
      data.closed();
    }
  }
}
