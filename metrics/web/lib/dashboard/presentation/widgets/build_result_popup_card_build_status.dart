// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/rive_animation.dart';
import 'package:metrics/common/presentation/value_image/widgets/value_network_image.dart';
import 'package:metrics/dashboard/presentation/view_models/project_build_status_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_popup_card.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_popup_image_strategy.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:rive/rive.dart';

/// A widget that displays a [BuildStatus] of a build for the
/// [BuildResultPopupCard] widget.
class BuildResultPopupCardBuildStatus extends StatelessWidget {
  /// A [ProjectBuildStatusViewModel] with a [BuildStatus] to display.
  final ProjectBuildStatusViewModel projectBuildStatus;

  /// Creates a new instance of the [BuildResultPopupCardBuildStatus]
  /// with the given [projectBuildStatus].
  ///
  /// Throws an [AssertionError] if the given [projectBuildStatus] is `null`.
  const BuildResultPopupCardBuildStatus({
    Key key,
    @required this.projectBuildStatus,
  })  : assert(projectBuildStatus != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final buildStatus = projectBuildStatus.value;

    if (buildStatus == BuildStatus.inProgress) {
      return RiveAnimation(
        'web/animation/in_progress_popup_build_status.riv',
        useArtboardSize: true,
        controller: SimpleAnimation('Animation 1'),
      );
    }

    return ValueNetworkImage<BuildStatus>(
      width: 24.0,
      height: 24.0,
      value: buildStatus,
      strategy: const BuildResultPopupImageStrategy(),
    );
  }
}
