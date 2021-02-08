// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

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
  ///
  /// The given [outerDiameter] must be greater than the given [innerDiameter].
  const CircleGraphIndicator({
    Key key,
    @required this.outerDiameter,
    @required this.innerDiameter,
    this.outerColor = Colors.black,
    this.innerColor = Colors.white,
  })  : assert(outerDiameter != null),
        assert(innerDiameter != null),
        assert(outerDiameter > innerDiameter),
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
