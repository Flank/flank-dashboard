// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A callback used for widget builder functions that depend on the hover status.
typedef HoverWidgetBuilder = Widget Function(
  BuildContext context,
  bool isHovered,
);

/// A callback that is used for widget builder functions that depend on the hover
/// status and may have immutable subtree independent of hover status updates.
typedef HoverWidgetChildBuilder = Widget Function(
  BuildContext context,
  bool isHovered,
  Widget child,
);

/// A widget that rebuilds its child using the given builder function
/// and applies the given cursor when this widget is hovered,
/// applies the given callback when this widget is tapped.
class TappableArea extends StatefulWidget {
  /// A callback that is called when the area is tapped.
  final VoidCallback onTap;

  /// A cursor that is used when the area is hovered.
  final MouseCursor mouseCursor;

  /// A widget builder that builds the given widget differently depending on
  /// if the this area is hovered.
  final HoverWidgetChildBuilder builder;

  /// A widget that does not depend on hover updates.
  /// The [builder] is called with the given child parameter.
  final Widget child;

  /// How the [TappableArea] should behave during hit testing.
  final HitTestBehavior hitTestBehavior;

  /// Creates a new [TappableArea] instance.
  ///
  /// The [builder] must not be null.
  ///
  /// If the [hitTestBehavior] is not provided, the [HitTestBehavior.opaque]
  /// is used.
  ///
  /// The [mouseCursor] value defaults to [SystemMouseCursors.click].
  const TappableArea({
    Key key,
    @required this.builder,
    this.onTap,
    this.child,
    this.hitTestBehavior = HitTestBehavior.opaque,
    MouseCursor mouseCursor,
  })  : assert(builder != null),
        mouseCursor = mouseCursor ?? SystemMouseCursors.click,
        super(key: key);

  @override
  _TappableAreaState createState() => _TappableAreaState();
}

class _TappableAreaState extends State<TappableArea> {
  /// Indicates whether this area is hovered.
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.mouseCursor,
      onEnter: (_) => _changeHover(true),
      onExit: (_) => _changeHover(false),
      child: GestureDetector(
        behavior: widget.hitTestBehavior,
        onTap: widget.onTap,
        child: widget.builder(context, _isHovered, widget.child),
      ),
    );
  }

  /// Changes [_isHovered] value to the given [value].
  void _changeHover(bool value) {
    setState(() => _isHovered = value);
  }
}
