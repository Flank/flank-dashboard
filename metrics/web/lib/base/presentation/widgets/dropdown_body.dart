// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/dropdown_menu.dart';
import 'package:selection_menu/components_configurations.dart';

/// A builder that builds its child differently depending on the
/// given [animation] state.
typedef AnimatedWidgetBuilder = Widget Function(
  BuildContext context,
  CurvedAnimation animation,
);

/// A widget that used with [DropdownMenu] to display open dropdown body.
///
/// Animates the child using the given [builder], [animationCurve] and
/// [animationDuration] depending on the [state].
class DropdownBody extends StatefulWidget {
  /// A current state of the [DropdownMenu].
  final MenuState state;

  /// A [Curve] to use in the animation.
  final Curve animationCurve;

  /// A [Duration] to use in the animation.
  final Duration animationDuration;

  /// A max height of this dropdown body.
  final double maxHeight;

  /// A max width of this dropdown body.
  final double maxWidth;

  /// A decoration of this dropdown body.
  final BoxDecoration decoration;

  /// A [ValueChanged] callback used to notify about opened state changes.
  final ValueChanged<bool> onOpenStateChanged;

  /// An animated builder of the child of this dropdown body.
  final AnimatedWidgetBuilder builder;

  /// Creates a widget that displays an open [DropdownMenu] body.
  ///
  /// The [animationCurve] defaults to `Curves.linear`.
  /// The [animationDuration] defaults to a zero duration.
  ///
  /// The [builder] must not be `null`.
  /// The [state] must not be `null`.
  /// The [animationCurve] must not be `null`.
  /// The [animationDuration] must not be `null`.
  const DropdownBody({
    Key key,
    @required this.state,
    @required this.builder,
    this.animationCurve = Curves.linear,
    this.animationDuration = const Duration(),
    this.decoration = const BoxDecoration(),
    double maxHeight,
    double maxWidth,
    this.onOpenStateChanged,
  })  : maxHeight = maxHeight ?? double.infinity,
        maxWidth = maxWidth ?? double.infinity,
        assert(state != null),
        assert(builder != null),
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

    _handleMenuState();

    super.initState();
  }

  @override
  void didUpdateWidget(covariant DropdownBody oldWidget) {
    super.didUpdateWidget(oldWidget);

    _handleMenuState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: widget.maxHeight,
        maxWidth: widget.maxWidth,
      ),
      decoration: widget.decoration,
      child: widget.builder(context, _animation),
    );
  }

  /// Listens to animation status updates.
  void _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onOpenStateChanged?.call(true);
    } else if (status == AnimationStatus.dismissed) {
      widget.onOpenStateChanged?.call(false);
    }
  }

  /// Starts or reverts the animation depending on the current menu state.
  void _handleMenuState() {
    if (widget.state == MenuState.OpeningStart) {
      _controller.forward();
    } else if (widget.state == MenuState.ClosingStart) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
