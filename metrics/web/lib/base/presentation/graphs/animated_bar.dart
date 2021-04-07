// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:metrics/base/presentation/graphs/bar_graph.dart';
import 'package:metrics/base/presentation/widgets/rive_animation.dart';
import 'package:rive/rive.dart';

/// A widget that displays a rectangle animated bar of the [BarGraph].
class AnimatedBar extends StatelessWidget {
  /// A path to the [RiveAnimation] asset this bar displays.
  final String riveAsset;

  /// A height of this bar.
  final double height;

  /// A width of this bar.
  final double width;

  /// A [RiveAnimationController] to control this bar's animation.
  final RiveAnimationController controller;

  /// A a name of the [Artboard] to load for this bar's animation.
  final String artboardName;

  /// Creates a new instance of the [AnimatedBar] with the given parameters.
  ///
  /// The [riveAsset] must not be `null`.
  /// The [height], [width] must not be `null` or negative.
  const AnimatedBar({
    Key key,
    @required this.riveAsset,
    @required this.height,
    @required this.width,
    this.controller,
    this.artboardName,
  })  : assert(riveAsset != null),
        assert(height != null && height >= 0.0),
        assert(width != null && width >= 0.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: RiveAnimation(
        riveAsset,
        controller: controller,
        artboardName: artboardName,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
