import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

/// A widget that displays the given [child] widget and handles
/// the cursor appearance over this child widget.
class HandCursor extends StatelessWidget {
  /// A child widget of this widget the cursor has to be handled for.
  final Widget child;

  /// Creates the [HandCursor] widget with the given [child].
  const HandCursor({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      key: key,
      onEnter: (_) => _changeCursor('pointer'),
      onExit: (_) => _changeCursor('default'),
      child: child,
    );
  }

  /// Changes the cursor style to the given [value].
  void _changeCursor(String value) {
    final appContainer = html.window?.document?.getElementById('app-container');

    if (appContainer == null) return;

    appContainer.style.cursor = value;
  }
}
