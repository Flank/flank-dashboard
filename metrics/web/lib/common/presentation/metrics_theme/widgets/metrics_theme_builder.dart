// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_app/metrics_app.dart';
import 'package:metrics/common/presentation/metrics_theme/model/dark_metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/light_metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:provider/provider.dart';

/// A widget builder function that provides a [ThemeNotifier]
/// and a [BuildContext] to the children of the [MetricsThemeBuilder].
typedef ThemeBuilder = Widget Function(
    BuildContext context, ThemeNotifier themeNotifier);

/// Widget to rebuild the [MetricsApp] when the [ThemeNotifier] is changed.
class MetricsThemeBuilder extends StatelessWidget {
  /// A light variant of the [MetricsThemeData].
  final MetricsThemeData lightTheme;

  /// A dark variant of the [MetricsThemeData].
  final MetricsThemeData darkTheme;

  /// A [ThemeBuilder] used to build the child with the [ThemeNotifier] provided.
  final ThemeBuilder builder;

  /// Creates the [MetricsThemeBuilder].
  ///
  /// The [builder] should not be null.
  ///
  /// If the [lightTheme] is null, the [LightMetricsThemeData] used.
  /// If the [darkTheme] is null, the [DarkMetricsThemeData] used.
  ///
  /// Rebuilds a [MetricsApp] when a [ThemeNotifier] changes.
  MetricsThemeBuilder({
    Key key,
    @required this.builder,
    MetricsThemeData lightTheme,
    MetricsThemeData darkTheme,
  })  : assert(builder != null),
        lightTheme = lightTheme ?? LightMetricsThemeData(),
        darkTheme = darkTheme ?? DarkMetricsThemeData(),
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

  /// Gets a [MetricsThemeData] depending on [ThemeNotifier.isDark].
  MetricsThemeData _getThemeData(ThemeNotifier themeNotifier) {
    if (themeNotifier == null || !themeNotifier.isDark) return lightTheme;

    return darkTheme;
  }
}
