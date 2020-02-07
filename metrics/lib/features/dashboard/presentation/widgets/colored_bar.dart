import 'package:flutter/material.dart';

/// Rectangle bar of the [BarGraph] with painted in [color].
class ColoredBar extends StatelessWidget {
  final Color color;
  final BorderRadiusGeometry borderRadius;
  final BoxBorder border;
  final EdgeInsets padding;

  /// Creates the [ColoredBar].
  ///
  /// [padding] is the padding to inset this bar.
  /// [border] is the border decoration of this bar.
  /// [borderRadius] is the radius of the border of this bar.
  const ColoredBar({
    Key key,
    this.padding = const EdgeInsets.symmetric(horizontal: 4.0),
    this.color,
    this.borderRadius,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
          border: border,
        ),
      ),
    );
  }
}
