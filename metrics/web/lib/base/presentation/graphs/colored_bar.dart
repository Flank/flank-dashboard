// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/graphs/bar_graph.dart';
import 'package:metrics/base/presentation/widgets/decorated_container.dart';

/// A widget that displays a rectangle bar of the [BarGraph] painted in [color].
class ColoredBar extends StatelessWidget {
  /// A color of this bar.
  final Color color;

  /// A radius of the border of this bar.
  final BorderRadiusGeometry borderRadius;

  /// A border decoration of this bar.
  final BoxBorder border;

  /// A padding to inset this bar.
  final EdgeInsets padding;

  /// A width of this bar.
  final double width;

  /// A height of this bar.
  final double height;

  /// Creates the [ColoredBar].
  ///
  /// The [padding] defaults to the [EdgeInsets.zero].
  /// The [width] defaults to the `0.0`.
  ///
  /// The [width] must not be `null` or negative.
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
