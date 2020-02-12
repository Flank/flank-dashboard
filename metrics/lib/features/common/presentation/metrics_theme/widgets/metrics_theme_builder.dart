import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/metrics_theme/store/theme_store.dart';
import 'package:metrics/features/common/presentation/metrics_theme/widgets/metrics_app.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

/// Widget to rebuild the [MetricsApp] when the [ThemeStore] is changed.
class MetricsThemeBuilder extends StatelessWidget {
  final Widget child;

  /// Creates the [MetricsThemeBuilder].
  ///
  /// Rebuilds the [MetricsApp] when the [ThemeStore] changes.
  const MetricsThemeBuilder({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      models: [Injector.getAsReactive<ThemeStore>()],
      builderWithChild: (_, themeStore, child) {
        final themeSnapshot = themeStore.snapshot.data as ThemeStore;

        return MetricsApp(
          themeType: _getThemeType(themeSnapshot),
          child: child,
        );
      },
      child: child,
    );
  }

  /// Gets the [MetricsThemeType] from the [ThemeStore].
  MetricsThemeType _getThemeType(ThemeStore themeSnapshot) {
    if (themeSnapshot == null) return null;

    if (themeSnapshot.isDark) return MetricsThemeType.dark;

    return MetricsThemeType.light;
  }
}
