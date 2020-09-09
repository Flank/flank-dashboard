import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:metrics/base/presentation/constants/mouse_cursor.dart';
import 'package:universal_html/html.dart' as html;

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
  final Widget Function(BuildContext, bool) builder;

  /// Creates a new [TappableArea] instance.
  ///
  /// The [builder] must not be null.
  ///
  /// The [mouseCursor] value defaults to [MouseCursor.basic].
  const TappableArea({
    Key key,
    @required this.builder,
    this.onTap,
    MouseCursor mouseCursor,
  })  : assert(builder != null),
        mouseCursor = mouseCursor ?? MouseCursor.basic,
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
      onEnter: (_) => _changeHover(true),
      onExit: (_) => _changeHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: widget.builder(context, _isHovered),
      ),
    );
  }

  /// Changes [_isHovered] value to the given [value].
  void _changeHover(bool value) {
    setState(() => _isHovered = value);
    _changeCursor();
  }

  /// Changes the cursor depending on [_isHovered] value.
  void _changeCursor() {
    final appContainer = html.window?.document?.getElementById('app-container');

    if (appContainer == null) return;

    appContainer.style.cursor =
        _isHovered ? widget.mouseCursor.cursor : MouseCursor.basic.cursor;
  }
}
