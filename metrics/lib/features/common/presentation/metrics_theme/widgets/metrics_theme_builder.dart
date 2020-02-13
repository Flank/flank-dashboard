import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/dark_metrics_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/light_metrics_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/store/theme_store.dart';
import 'package:metrics/features/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

/// Widget to rebuild the [MetricsApp] when the [ThemeStore] is changed.
class MetricsThemeBuilder extends StatelessWidget {
  final MetricsThemeData lightTheme;
  final MetricsThemeData darkTheme;
  final Widget child;

  /// Creates the [MetricsThemeBuilder].
  ///
  /// Rebuilds the [MetricsApp] when the [ThemeStore] changes.
  const MetricsThemeBuilder({
    Key key,
    this.child,
    MetricsThemeData lightTheme,
    MetricsThemeData darkTheme,
  })  : lightTheme = lightTheme ?? const LightMetricsThemeData(),
        darkTheme = darkTheme ?? const DarkMetricsThemeData(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      models: [Injector.getAsReactive<ThemeStore>()],
      builderWithChild: (_, themeStore, child) {
        final themeSnapshot = themeStore.snapshot.data as ThemeStore;

        return MetricsTheme(
          data: _getThemeData(themeSnapshot),
          child: child,
        );
      },
      child: child,
    );
  }

  /// Gets the [MetricsThemeType] from the [ThemeStore].
  MetricsThemeData _getThemeData(ThemeStore themeSnapshot) {
    if (themeSnapshot == null || !themeSnapshot.isDark) return lightTheme;

    return darkTheme;
  }
}
