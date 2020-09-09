import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:provider/provider.dart';

/// A class that displays appropriate asset depending on the current theme mode.
class MetricsThemeModeImage extends StatelessWidget {
  /// An asset to display when the current theme mode is dark.
  final String darkAsset;

  /// An asset to display when the current theme mode is light.
  final String lightAsset;

  /// A width of the displayed asset.
  final double width;

  /// A height of the displayed asset.
  final double height;

  /// A parameter that controls hot to inscribe an asset into the space
  /// allocated during layout.
  final BoxFit fit;

  /// Creates a new instance of the [MetricsThemeModeImage].
  ///
  /// Both [darkAsset] and [lightAsset] must not be `null`.
  const MetricsThemeModeImage({
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
    return Selector<ThemeNotifier, bool>(
      selector: (_, notifier) => notifier.isDark,
      builder: (_, isDark, __) {
        return Image.network(
          isDark ? darkAsset : lightAsset,
          width: width,
          height: height,
          fit: fit,
        );
      },
    );
  }
}
