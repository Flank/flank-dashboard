import 'package:flutter/material.dart';
import 'package:selection_menu/components_configurations.dart';

/// A widget that displays the dropdown menu.
class ProjectGroupDropdownMenu extends StatefulWidget {
  /// An [AnimationComponentData] that provides an information about menu animation.
  final AnimationComponentData data;

  /// Creates a [ProjectGroupDropdownMenu] with the given [data].
  const ProjectGroupDropdownMenu({
    Key key,
    @required this.data,
  })  : assert(data != null),
        super(key: key);

  @override
  _ProjectGroupDropdownMenuState createState() =>
      _ProjectGroupDropdownMenuState();
}

class _ProjectGroupDropdownMenuState extends State<ProjectGroupDropdownMenu> {
  /// An animation controller used to animate the project group dropdown menu.
  AnimationController _controller;

  @override
  void initState() {
    final data = widget.data;
    _controller = AnimationController(
      duration: data.menuAnimationDurations.forward,
      reverseDuration: data.menuAnimationDurations.reverse,
      vsync: data.tickerProvider,
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
              horizontal: 2.0,
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
