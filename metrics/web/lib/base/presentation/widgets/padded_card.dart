import 'package:flutter/material.dart';

/// The widget that displays a card with the padding.
class PaddedCard extends StatelessWidget {
  /// An elevation of this card.
  final double elevation;

  /// A background color of this card.
  final Color backgroundColor;

  /// An empty space that surrounds this card.
  final EdgeInsetsGeometry margin;

  /// A widget below this card in the tree.
  final Widget child;

  /// An empty space that surrounds the [child].
  final EdgeInsetsGeometry padding;

  /// Creates a [PaddedCard].
  ///
  /// The [margin] and the [padding] default value is [EdgeInsets.zero].
  /// The [elevation] default value is 0.0.
  ///
  /// The [child] and the [backgroundColor] arguments must not be null.
  const PaddedCard({
    Key key,
    @required this.child,
    this.backgroundColor,
    this.elevation = 0.0,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
  })  : assert(child != null),
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
