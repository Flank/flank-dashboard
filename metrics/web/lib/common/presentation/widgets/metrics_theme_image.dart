// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/svg_image.dart';
import 'package:metrics/common/presentation/widgets/theme_mode_builder.dart';

/// A class that displays appropriate asset depending on the current theme mode.
class MetricsThemeImage extends StatelessWidget {
  /// An asset to display when the current theme mode is dark.
  final String darkAsset;

  /// An asset to display when the current theme mode is light.
  final String lightAsset;

  /// A width of the displayed asset.
  final double width;

  /// A height of the displayed asset.
  final double height;

  /// A parameter that controls how to inscribe an asset into the space
  /// allocated during layout.
  final BoxFit fit;

  /// Creates a new instance of the [MetricsThemeImage].
  ///
  /// Both [darkAsset] and [lightAsset] must not be `null`.
  const MetricsThemeImage({
    Key key,
    @required this.darkAsset,
    @required this.lightAsset,
    this.width,
    this.height,
    this.fit,
  })  : assert(darkAsset != null),
        assert(lightAsset != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemeModeBuilder(
      builder: (_, isDark, __) {
        return SvgImage(
          isDark ? darkAsset : lightAsset,
          width: width,
          height: height,
          fit: fit,
        );
      },
    );
  }
}
