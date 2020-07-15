import 'package:flutter/material.dart';
import 'package:selection_menu/components_configurations.dart';

/// A widget that displays the dropdown body.
class DropdownBody extends StatefulWidget {
  /// A [Curve] to use in the animation.
  final Curve animationCurve;

  /// A [Duration] to use in the animation.
  final Duration animationDuration;

  /// A max height of this this dropdown body.
  final double maxHeight;

  /// A [ValueChanged] callback used to notify about opened state changes.
  final ValueChanged<bool> onOpenedStateChanged;

  /// A current state of this widget.
  final MenuState state;

  /// A child widget of this dropdown body.
  final Widget child;

  /// Creates a [DropdownBody].
  ///
  /// The [animationCurve] defaults to `Curves.linear`.
  /// The [animationDuration] defaults to a zero duration.
  ///
  /// The [state] must not be null.
  /// The [animationCurve] must not be null.
  /// The [animationDuration] must not be null.
  const DropdownBody({
    Key key,
    @required this.state,
    this.animationCurve = Curves.linear,
    this.animationDuration = const Duration(),
    this.maxHeight,
    this.onOpenedStateChanged,
    this.child,
  })  : assert(state != null),
        assert(animationCurve != null),
        assert(animationDuration != null),
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
    _controller = AnimationController(
      duration: widget.animationDuration,
      reverseDuration: widget.animationDuration,
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve,
      reverseCurve: widget.animationCurve,
    );

    _animation.addStatusListener(_animationStatusListener);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state == MenuState.OpeningStart) {
      _controller.forward();
    } else if (widget.state == MenuState.ClosingStart) {
      _controller.reverse();
    }

    return Container(
      constraints: BoxConstraints(
        maxHeight: widget.maxHeight,
      ),
      child: SizeTransition(
        sizeFactor: _animation,
        child: widget.child,
      ),
    );
  }

  /// Listens to animation status updates.
  void _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onOpenedStateChanged?.call(true);
    } else if (status == AnimationStatus.dismissed) {
      widget.onOpenedStateChanged?.call(false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
