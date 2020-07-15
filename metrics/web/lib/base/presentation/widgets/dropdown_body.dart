import 'package:flutter/material.dart';
import 'package:selection_menu/components_configurations.dart';

/// A [Function] used to build a dropdown body.
typedef DropdownBodyBuilder = Widget Function(
  BuildContext context,
  Widget child,
);

/// A widget that displays the dropdown body.
class DropdownBody extends StatefulWidget {
  /// An [AnimationComponentData] that provides an information
  /// about dropdown body animation.
  final AnimationComponentData data;

  /// A [DropdownBodyBuilder] used to build a dropdown body.
  final DropdownBodyBuilder builder;

  /// Creates a [DropdownBody] with the given [data] and the [builder].
  ///
  /// The [data] and the [builder] must not be null.
  const DropdownBody({
    Key key,
    @required this.data,
    @required this.builder,
  })  : assert(data != null),
        assert(builder != null),
        super(key: key);

  @override
  _DropdownBodyState createState() => _DropdownBodyState();
}

class _DropdownBodyState extends State<DropdownBody>
    with SingleTickerProviderStateMixin {
  /// An animation controller used to control the dropdown body animation.
  AnimationController _controller;

  /// An animation used to animate the dropdown body.
  CurvedAnimation _animation;

  @override
  void initState() {
    final data = widget.data;
    _controller = AnimationController(
      duration: data.menuAnimationDurations.forward,
      reverseDuration: data.menuAnimationDurations.reverse,
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: data.menuAnimationCurves.forward,
      reverseCurve: data.menuAnimationCurves.reverse,
    );

    _animation.addStatusListener(_animationStatusListener);

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
      constraints: BoxConstraints(
        maxHeight: data.constraints.biggest.height,
      ),
      child: SizeTransition(
        sizeFactor: _animation,
        child: widget.builder(context, data.child),
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
