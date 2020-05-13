import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/dark_metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/light_metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:provider/provider.dart';

typedef ThemeBuilder = Widget Function(
    BuildContext context, ThemeNotifier themeNotifier);

/// Widget to rebuild the [MetricsApp] when the [ThemeNotifier] is changed.
class MetricsThemeBuilder extends StatelessWidget {
  final MetricsThemeData lightTheme;
  final MetricsThemeData darkTheme;
  final ThemeBuilder builder;

  /// Creates the [MetricsThemeBuilder].
  ///
  /// The [builder] should not be null.
  ///
  /// Rebuilds a [MetricsApp] when a [ThemeNotifier] changes.
  /// [builder] is the function used to build the child depending
  /// on current theme state.
  const MetricsThemeBuilder({
    Key key,
    @required this.builder,
    MetricsThemeData lightTheme,
    MetricsThemeData darkTheme,
  })  : assert(builder != null),
        lightTheme = lightTheme ?? const LightMetricsThemeData(),
        darkTheme = darkTheme ?? const DarkMetricsThemeData(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (_, themeNotifier, __) {
        return MetricsTheme(
          data: _getThemeData(themeNotifier),
          child: builder(context, themeNotifier),
        );
      },
    );
  }

  /// Gets a [MetricsThemeData] from a [ThemeNotifier].
  MetricsThemeData _getThemeData(ThemeNotifier themeNotifier) {
    if (themeNotifier == null || !themeNotifier.isDark) return lightTheme;

    return darkTheme;
  }
}
