// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:metrics/base/presentation/graphs/animated_bar.dart';
import 'package:metrics/base/presentation/widgets/rive_animation.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:rive/rive.dart';

/// A widget that displays the the bar with the in-progress [RiveAnimation].
class InProgressAnimatedBar extends StatelessWidget {
  /// A [String] representing a path to the [RiveAnimation] asset this bar
  /// displays.
  final String riveAsset;

  /// A [RiveAnimationController] to control this bar's animation.
  final RiveAnimationController controller;

  /// A [String] representing a name of the [Artboard] to load for this bar's
  /// animation.
  final String artboardName;

  /// A height of this bar.
  final double height;

  /// Creates a new instance of the [InProgressAnimatedBar] with the given
  /// parameters.
  ///
  /// Throws an [AssertionError] if the given [riveAsset] or [height] is `null`.
  const InProgressAnimatedBar({
    Key key,
    @required this.riveAsset,
    @required this.height,
    this.controller,
    this.artboardName,
  })  : assert(riveAsset != null),
        assert(height != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    const barWidth = DimensionsConfig.graphBarWidth;

    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedBar(
        fit: BoxFit.fitWidth,
        height: height,
        width: barWidth,
        riveAsset: riveAsset,
        controller: controller,
        artboardName: artboardName,
      ),
    );
  }
}
