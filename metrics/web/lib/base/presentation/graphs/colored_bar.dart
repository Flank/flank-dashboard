import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/decorated_container.dart';

/// Rectangle bar of the [BarGraph] painted in [color].
class ColoredBar extends StatelessWidget {
  /// The color of this bar.
  final Color color;

  /// The radius of the border of this bar.
  final BorderRadiusGeometry borderRadius;

  /// The border decoration of this bar.
  final BoxBorder border;

  /// The padding to inset this bar.
  final EdgeInsets padding;

  /// The width of this bar.
  final double width;

  /// The height of this bar.
  final double height;

  /// Creates the [ColoredBar].
  ///
  /// The [padding] defaults to the [EdgeInsets.zero].
  const ColoredBar({
    Key key,
    this.padding = EdgeInsets.zero,
    this.color,
    this.borderRadius,
    this.border,
    this.width = 0.0,
    this.height,
  })  : assert(width != null && width >= 0.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: DecoratedContainer(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
          border: border,
        ),
      ),
    );
  }
}
