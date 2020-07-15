import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/dropdown_body.dart';
import 'package:metrics/common/presentation/constants/duration_constants.dart';
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
    return DropdownBody(
      state: data.menuState,
      animationCurve: Curves.linear,
      animationDuration: DurationConstants.animation,
      maxHeight: data.constraints.maxHeight,
      onOpenedStateChanged: _onOpenedStateChanges,
      child: Container(
        width: 212.0,
        child: Card(
          margin: const EdgeInsets.only(top: 4.0),
          color: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Padding(
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
  void _onOpenedStateChanges(bool isOpened) {
    if (isOpened) {
      data.opened();
    } else {
      data.closed();
    }
  }
}
