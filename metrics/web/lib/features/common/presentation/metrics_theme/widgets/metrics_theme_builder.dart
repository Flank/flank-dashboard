import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/dark_metrics_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/light_metrics_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/store/theme_store.dart';
import 'package:metrics/features/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

typedef ThemeBuilder = Widget Function(BuildContext context, ThemeStore store);

/// Widget to rebuild the [MetricsApp] when the [ThemeStore] is changed.
class MetricsThemeBuilder extends StatelessWidget {
  final MetricsThemeData lightTheme;
  final MetricsThemeData darkTheme;
  final ThemeBuilder builder;

  /// Creates the [MetricsThemeBuilder].
  ///
  /// The [builder] should not be null.
  ///
  /// Rebuilds the [MetricsApp] when the [ThemeStore] changes.
  /// [builder] is the function used to build the child depending
  /// on current theme store state.
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
    return StateBuilder(
      models: [Injector.getAsReactive<ThemeStore>()],
      builder: (_, themeStore) {
        final themeSnapshot = themeStore.snapshot.data as ThemeStore;

        return MetricsTheme(
          data: _getThemeData(themeSnapshot),
          child: builder(context, themeSnapshot),
        );
      },
    );
  }

  /// Gets the [MetricsThemeType] from the [ThemeStore].
  MetricsThemeData _getThemeData(ThemeStore themeSnapshot) {
    if (themeSnapshot == null || !themeSnapshot.isDark) return lightTheme;

    return darkTheme;
  }
}
