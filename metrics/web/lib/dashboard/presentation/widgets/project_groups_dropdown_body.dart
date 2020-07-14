import 'package:flutter/material.dart';
import 'package:selection_menu/components_configurations.dart';

/// A widget that displays the dropdown body.
class ProjectGroupsDropdownBody extends StatefulWidget {
  /// An [AnimationComponentData] that provides an information
  /// about dropdown body animation.
  final AnimationComponentData data;

  /// Creates a [ProjectGroupsDropdownBody] with the given [data].
  ///
  /// The [data] must not be null.
  const ProjectGroupsDropdownBody({
    Key key,
    @required this.data,
  })  : assert(data != null),
        super(key: key);

  @override
  _ProjectGroupsDropdownBodyState createState() =>
      _ProjectGroupsDropdownBodyState();
}

class _ProjectGroupsDropdownBodyState extends State<ProjectGroupsDropdownBody>
    with SingleTickerProviderStateMixin {
  /// An animation controller used to animate the project group dropdown body.
  AnimationController _controller;

  @override
  void initState() {
    final data = widget.data;
    _controller = AnimationController(
      duration: data.menuAnimationDurations.forward,
      reverseDuration: data.menuAnimationDurations.reverse,
      vsync: this,
    );

    _controller.addStatusListener(_animationStatusListener);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    if (data.menuState == MenuState.OpeningStart) {
      _controller.forward();
    } else if (data.menuState == MenuState.ClosingStart) {
      _controller.reverse();
    }

    return Container(
      width: 212.0,
      constraints: BoxConstraints(
        maxHeight: data.constraints.biggest.height,
      ),
      child: Card(
        margin: const EdgeInsets.only(top: 4.0),
        color: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: SizeTransition(
          sizeFactor: _controller,
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

  /// Listens to animation status updates.
  void _animationStatusListener(AnimationStatus status) {
    final data = widget.data;

    if (status == AnimationStatus.completed) {
      data.opened();
    } else if (status == AnimationStatus.dismissed) {
      data.closed();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
