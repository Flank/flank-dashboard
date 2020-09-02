import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

class TappableArea extends StatefulWidget {
  /// A callback that is called when the area is tapped.
  final VoidCallback onTap;

  /// A cursor that is used when the area is hovered.
  final String cursor;

  /// A widget builder that builds the given widget differently depending on
  /// if the this area is hovered.
  final Widget Function(bool) builder;

  /// Creates a new [TappableArea] instance.
  ///
  /// The [builder] must not be null.
  ///
  /// The [cursor] value defaults to `default`.
  const TappableArea({
    Key key,
    @required this.builder,
    this.onTap,
    String cursor,
  })  : assert(builder != null),
        cursor = cursor ?? 'default',
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
        child: widget.builder(_isHovered),
      ),
    );
  }

  /// Changes [_isHovered] value to the given [value].
  void _changeHover(bool value) {
    setState(() {
      _isHovered = value;
    });
    _changeCursor();
  }

  /// Changes the cursor depending on [_isHovered] value.
  void _changeCursor() {
    final appContainer = html.window?.document?.getElementById('app-container');

    if (appContainer == null) return;

    appContainer.style.cursor = _isHovered ? widget.cursor : 'default';
  }
}
