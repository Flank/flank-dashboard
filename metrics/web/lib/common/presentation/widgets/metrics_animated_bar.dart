// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:metrics/base/presentation/widgets/rive_animation.dart';

/// A widget that displays the the bar with the in-progress [RiveAnimation].
class MetricsAnimatedBar extends StatelessWidget {
  /// A height of this bar.
  final double height;

  /// A flag that indicates whether this bar is hovered.
  final bool isHovered;

  /// Creates a new instance of the [MetricsAnimatedBar] with the given
  /// parameters.
  ///
  /// Throws an [AssertionError] if the given [isHovered] is `null`.
  const MetricsAnimatedBar({
    Key key,
    this.height,
    @required this.isHovered,
  })  : assert(isHovered != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: isHovered
            ? const RiveAnimation(
                'assets/in_progress.riv',
              )
            : const RiveAnimation('asset/in_progress_hovered.riv'),
      ),
    );
  }
}
