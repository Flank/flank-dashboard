// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/rive_animation.dart';
import 'package:metrics/common/presentation/asset/strategy/value_based_asset_strategy.dart';
import 'package:metrics/common/presentation/value_image/widgets/value_network_image.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:rive/rive.dart';

/// A widget that displays the specified [BuildStatus] of the build.
class BuildStatusView extends StatelessWidget {
  /// A [BuildStatus] this widget displays.
  final BuildStatus buildStatus;

  /// A [ValueBasedAssetStrategy] this widget uses to select the assets
  /// depending on the given [buildStatus] value.
  final ValueBasedAssetStrategy<BuildStatus> strategy;

  /// A height applied to the [ValueNetworkImage] widget.
  final double height;

  /// A width applied to the [ValueNetworkImage] widget.
  final double width;

  /// Creates a new instance of the [BuildStatusView] with the given
  /// parameters.
  ///
  /// Throws an [AssertionError] if the given [strategy] or [buildStatus]
  /// is `null`.
  const BuildStatusView({
    Key key,
    @required this.strategy,
    @required this.buildStatus,
    this.height,
    this.width,
  })  : assert(strategy != null),
        assert(buildStatus != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final asset = strategy.getAsset(buildStatus);

    if (buildStatus == BuildStatus.inProgress) {
      return RiveAnimation(
        asset,
        useArtboardSize: true,
        controller: SimpleAnimation('Animation 1'),
      );
    }

    return ValueNetworkImage<BuildStatus>(
      width: width,
      height: height,
      value: buildStatus,
      strategy: strategy,
    );
  }
}
