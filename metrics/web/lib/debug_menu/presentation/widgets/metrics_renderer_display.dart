import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/util/web_platform.dart';

/// A widget that displays the current renderer.
class MetricsRendererDisplay extends StatelessWidget {
  /// A [WebPlatform] of this renderer display.
  final WebPlatform platform;

  /// Returns [CommonStrings.skia] if the application uses `Skia` renderer.
  ///
  /// Otherwise, returns [CommonStrings.html].
  String get _currentRendererText {
    final isSkia = platform.isSkia;

    return CommonStrings.currentRenderer(isSkia: isSkia);
  }

  /// Creates a new instance of the [MetricsRendererDisplay]
  /// with the given [platform].
  ///
  /// If the given [platform] is `null`, an instance
  /// of the [WebPlatform] is used.
  const MetricsRendererDisplay({
    Key key,
    WebPlatform platform,
  })  : platform = platform ?? const WebPlatform(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = MetricsTheme.of(context).debugMenuTheme;
    final contentTextStyle = theme.sectionContentTextStyle;

    return Text(_currentRendererText, style: contentTextStyle);
  }
}
