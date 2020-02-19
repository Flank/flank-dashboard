import 'package:flutter/material.dart';

/// Rectangle bar of the [BarGraph] with painted in [color].
class ColoredBar extends StatelessWidget {
  final Color color;
  final BorderRadiusGeometry borderRadius;
  final BoxBorder border;
  final EdgeInsets padding;
  final double width;

  /// Creates the [ColoredBar].
  ///
  /// [padding] is the padding to inset this bar.
  /// [border] is the border decoration of this bar.
  /// [borderRadius] is the radius of the border of this bar.
  /// [color] is the color of this bar.
  /// [width] is the width of the bar.
  const ColoredBar({
    Key key,
    this.padding = EdgeInsets.zero,
    this.color,
    this.borderRadius,
    this.border,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
          border: border,
        ),
      ),
    );
  }
}
