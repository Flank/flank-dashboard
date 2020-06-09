import 'package:flutter/material.dart';

/// Displays a metrics card widget.
class MetricsCard extends StatelessWidget {
  final double elevation;
  final Color backgroundColor;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Widget child;

  /// Creates a widget that represents a specific version of a [Card].
  ///
  /// The metrics card has the specific [backgroundColor].
  /// The given [child] is a widget, that displays inside the [Card].
  /// The child has a [padding] that is [EdgeInsets.zero] value by default.
  /// The card itself a [margin], that [EdgeInsets.zero] value by default.
  /// The [elevation] argument has a default value of 0.0.
  /// 
  /// The [child] and the [backgroundColor] arguments should not be null.
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
