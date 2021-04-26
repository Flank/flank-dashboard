import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/rive_animation.dart';
import 'package:metrics/common/presentation/widgets/theme_type_builder.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:rive/rive.dart';

/// A widget that displays an animated project build status that have the
/// [BuildStatus.inProgress].
class InProgressProjectBuildStatus extends StatelessWidget {
  /// Creates a new instance of the [InProgressProjectBuildStatus].
  const InProgressProjectBuildStatus({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemeTypeBuilder(
      builder: (_, isDark) {
        final asset = _getAssetPath(isDark);

        return RiveAnimation(
          asset,
          useArtboardSize: true,
          controller: SimpleAnimation('Animation 1'),
        );
      },
    );
  }

  /// Selects a proper animation asset depending on the current [isDark] theme
  /// state.
  String _getAssetPath(bool isDark) {
    const animationAssetsPath = 'web/animation';

    if (isDark) {
      return '$animationAssetsPath/in_progress_project_build_status.riv';
    }

    return '$animationAssetsPath/in_progress_project_build_status_light.riv';
  }
}
