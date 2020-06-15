import 'package:flutter/material.dart';

/// Displays a metrics card widget.
class MetricsCard extends StatelessWidget {
  /// An elevation of the [MetricsCard].
  ///
  /// Has a default value of [0.0].
  final double elevation;

  /// A background color of the [MetricsCard].
  final Color backgroundColor;

  /// An empty space that surrounds the [MetricsCard].
  ///
  /// Has a default value of [EdgeInsets.zero].
  final EdgeInsetsGeometry margin;

  /// An empty space that surrounds the [child].
  ///
  /// Has a default value of [EdgeInsets.zero].
  final EdgeInsetsGeometry padding;

  /// A widget below this widget in the tree.
  final Widget child;

  /// Creates a widget that represents a specific version of a [Card].
  ///
  /// The [child] and the [backgroundColor] arguments must not be null.
  const MetricsCard({
    Key key,
    @required this.child,
    @required this.backgroundColor,
    this.elevation = 0.0,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
  })  : assert(child != null),
        assert(backgroundColor != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      elevation: elevation,
      color: backgroundColor,
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
