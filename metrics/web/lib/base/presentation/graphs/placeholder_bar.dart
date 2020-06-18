import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/graphs/colored_bar.dart';

/// Represents the placeholder bar of the [BarGraph].
class PlaceholderBar extends StatelessWidget {
  /// The width of this bar.
  final double width;

  /// The color of this bar.
  final Color color;

  /// Creates the [PlaceholderBar].
  ///
  /// Either [width] and [color] must not be `null`.
  /// The [width] should be positive.
  ///
  /// This bar displays the missing/empty build in [BarGraph].
  const PlaceholderBar({
    Key key,
    this.width = 0.0,
    Color color,
  })  : assert(width != null && width >= 0.0),
        color = color ?? Colors.grey,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      height: 6.0,
      child: ColoredBar(
        color: color,
        width: width,
        border: Border.all(
          color: color,
          width: 2.0,
        ),
      ),
    );
  }
}
