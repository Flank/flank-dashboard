import 'package:flutter/material.dart';

/// A widget that displays a circle as an indicator for the graphs
/// or graph elements.
class CircleGraphIndicator extends StatelessWidget {
  /// A [Color] of the outer circle.
  final Color outerColor;

  /// A [Color] of the inner circle.
  final Color innerColor;

  /// A diameter of the outer circle.
  final double outerDiameter;

  /// A diameter of the inner circle.
  final double innerDiameter;

  /// Creates a new instance of the [CircleGraphIndicator].
  ///
  /// The [outerColor] default value is [Colors.black].
  /// The [innerColor] default value is [Colors.white].
  /// The [outerDiameter] default value is `5.0`.
  /// The [innerDiameter] default value is `2.0`.
  ///
  /// The given [outerDiameter] must be greater than the given [innerDiameter].
  const CircleGraphIndicator({
    Key key,
    this.outerColor = Colors.black,
    this.innerColor = Colors.white,
    this.outerDiameter = 5.0,
    this.innerDiameter = 2.0,
  })  : assert(outerDiameter > innerDiameter),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: outerDiameter,
      width: outerDiameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: outerColor,
      ),
      child: Container(
        height: innerDiameter,
        width: innerDiameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: innerColor,
        ),
      ),
    );
  }
}
