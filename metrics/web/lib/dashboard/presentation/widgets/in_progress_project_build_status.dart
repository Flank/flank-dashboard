// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/rive_animation.dart';
import 'package:metrics/common/presentation/widgets/theme_mode_builder.dart';
import 'package:metrics/dashboard/presentation/widgets/project_build_status.dart';
import 'package:rive/rive.dart';

/// A widget that displays the in-progress build status animation to display on
/// the [ProjectBuildStatus].
class InProgressProjectBuildStatus extends StatelessWidget {
  /// Creates a new instance of the [InProgressProjectBuildStatus].
  const InProgressProjectBuildStatus({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemeModeBuilder(
      builder: (_, isDark, __) {
        final asset = _selectAsset(isDark);

        return RiveAnimation(
          asset,
          useArtboardSize: true,
          controller: SimpleAnimation('Animation 1'),
        );
      },
    );
  }

  /// Selects an animation asset depending on the given [isDark] value that
  /// represents the current theme mode state.
  String _selectAsset(bool isDark) {
    final prefix = isDark ? 'dark' : 'light';

    return 'web/animation/in_progress_project_build_status_$prefix.riv';
  }
}
