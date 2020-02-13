import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/dark_metrics_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/light_metrics_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/widgets/metrics_theme.dart';

enum MetricsThemeType { light, dark }

/// The widget to manage the current [MetricsThemeData].
class MetricsApp extends StatelessWidget {
  final MetricsThemeData lightTheme;
  final MetricsThemeData darkTheme;
  final MetricsThemeType themeType;
  final Widget child;

  /// Creates the [MetricsApp] widget.
  ///
  /// The [lightTheme] and [darkTheme] are never null.
  /// If noting passed the default values will be used.
  /// [child] it the child widget the current theme to be applied.
  const MetricsApp({
    Key key,
    @required this.child,
    MetricsThemeData lightTheme,
    MetricsThemeData darkTheme,
    MetricsThemeType themeType,
  })  : lightTheme = lightTheme ?? const LightMetricsThemeData(),
        darkTheme = darkTheme ?? const DarkMetricsThemeData(),
        themeType = themeType ?? MetricsThemeType.light,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsTheme(
      data: themeType == MetricsThemeType.light ? lightTheme : darkTheme,
      child: child,
    );
  }
}
