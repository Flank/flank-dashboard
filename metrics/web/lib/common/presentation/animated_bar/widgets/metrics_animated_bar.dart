// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/graphs/colored_bar.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';

/// A widget that displays the animated bar for the graphs.
class MetricsAnimatedBar extends StatelessWidget {
  /// A height of this bar.
  final double height;

  /// Indicates whether this widget is hovered.
  final bool isHovered;

  /// Creates a new instance of the [MetricsColoredBar].
  ///
  /// The [isHovered] default value is `false`.
  const MetricsAnimatedBar({
    Key key,
    this.isHovered = false,
    this.height,
  })  : assert(isHovered != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    const borderRadius = Radius.circular(1.0);
    const barWidth = DimensionsConfig.graphBarWidth;

    return Container(
      width: barWidth,
      alignment: Alignment.bottomCenter,
      child: ColoredBar(
        width: barWidth,
        height: height,
        borderRadius: const BorderRadius.only(
          topLeft: borderRadius,
          topRight: borderRadius,
        ),
        color: isHovered ? Colors.black : Colors.grey,
      ),
    );
  }
}
