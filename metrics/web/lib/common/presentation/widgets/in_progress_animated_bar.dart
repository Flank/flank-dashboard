// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:metrics/base/presentation/graphs/animated_bar.dart';
import 'package:metrics/base/presentation/widgets/rive_animation.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:rive/rive.dart';

/// A widget that displays the the bar with the in-progress [RiveAnimation].
class InProgressAnimatedBar extends StatelessWidget {
  /// A height of this bar.
  final double height;

  /// A width of this bar.
  final double width;

  /// A flag that indicates whether this animated bar is hovered.
  final bool isHovered;

  /// A [RiveAnimationController] to control this bar's animation.
  final RiveAnimationController controller;

  /// Creates a new instance of the [InProgressAnimatedBar] with the given
  /// parameters.
  ///
  /// The [width] defaults to the [DimensionsConfig.graphBarWidth].
  /// The [isHovered] defaults to `false`
  ///
  /// Throws an [AssertionError] if the given [isHovered] is `null`.
  /// Throws an [AssertionError] if the given [height] or [width]
  /// is `null` or negative.
  const InProgressAnimatedBar({
    Key key,
    @required this.height,
    this.width = DimensionsConfig.graphBarWidth,
    this.isHovered = false,
    this.controller,
  })  : assert(height != null && height >= 0),
        assert(width != null && width >= 0),
        assert(isHovered != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    const animationRootPath = 'web/animation';
    final asset = isHovered
        ? '$animationRootPath/in_progress_bar_hover.riv'
        : '$animationRootPath/in_progress_bar.riv';

    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedBar(
        riveAsset: asset,
        height: height,
        width: width,
        controller: controller,
      ),
    );
  }
}
