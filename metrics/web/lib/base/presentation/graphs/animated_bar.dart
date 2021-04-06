// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/base/presentation/graphs/bar_graph.dart';
import 'package:metrics/base/presentation/widgets/rive_animation.dart';
import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart';

/// A widget that displays a rectangle animated bar of the [BarGraph].
class AnimatedBar extends StatelessWidget {
  /// A width of this bar.
  final double width;

  /// A height of this bar.
  final double height;

  /// A [String] representing a path to the [RiveAnimation] asset this bar
  /// displays.
  final String riveAsset;

  /// A [BoxFit] that determines how to inscribe this animation into the space
  /// allocated during layout.
  final BoxFit fit;

  /// A [RiveAnimationController] to control this bar's animation.
  final RiveAnimationController controller;

  /// A [String] representing a name of the [Artboard] to load for this bar's
  /// animation.
  final String artboardName;

  /// Creates a new instance of the [AnimatedBar] with the given parameters.
  ///
  /// The [width] defaults to the `0.0`.
  ///
  /// The [width] must not be `null` or negative.
  const AnimatedBar({
    Key key,
    this.fit,
    this.height,
    this.riveAsset,
    this.controller,
    this.artboardName,
    this.width = 0.0,
  })  : assert(width != null && width >= 0.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: RiveAnimation(
        riveAsset,
        fit: fit,
        controller: controller,
        artboardName: artboardName,
      ),
    );
  }
}
