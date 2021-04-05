// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:metrics/base/presentation/widgets/rive_animation.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:rive/rive.dart';

/// A widget that displays the the bar with the in-progress [RiveAnimation].
class MetricsAnimatedBar extends StatelessWidget {
  /// A height of this bar.
  final double height;

  /// A flag that indicates whether this bar is hovered.
  final bool isHovered;

  /// Creates a new instance of the [MetricsAnimatedBar] with the given
  /// [isHovered] and [height].
  ///
  /// Throws an [AssertionError] if the given [height] or [isHovered] is `null`.
  const MetricsAnimatedBar({
    Key key,
    @required this.height,
    @required this.isHovered,
  })  : assert(height != null),
        assert(isHovered != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    const barWidth = DimensionsConfig.graphBarWidth;
    const asset = 'web/animation/in_progress_bar.riv';
    const animationName = 'Animation 1';

    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: height,
        width: barWidth,
        child: RiveAnimation(
          asset,
          fit: BoxFit.fitWidth,
          controller: SimpleAnimation(animationName),
        ),
      ),
    );
  }
}
