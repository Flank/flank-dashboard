import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/dark_metrics_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/light_metrics_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/store/theme_store.dart';
import 'package:metrics/features/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/features/common/presentation/metrics_theme/widgets/metrics_theme_builder.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

void main() {
  testWidgets(
    "Changes the theme on store changing",
    (WidgetTester tester) async {
      final store = ThemeStore();

      await tester.pumpWidget(MetricsThemeBuilderTestbed(
        themeStore: store,
      ));

      final themeWidget = tester.widget<MetricsTheme>(
        find.byType(MetricsTheme),
      );

      final currentTheme = themeWidget.data;

      final stateBuilderWidget = tester.widget<StateBuilder>(find.descendant(
        of: find.byType(MetricsThemeBuilder),
        matching: find.byType(StateBuilder),
      ));

      final themeStoreModel =
          stateBuilderWidget.models.first as ReactiveModel<ThemeStore>;

      await themeStoreModel.setState((model) => model.isDark = true);
      await tester.pump();

      final newThemeWidget = tester.widget<MetricsTheme>(
        find.byType(MetricsTheme),
      );

      final newTheme = newThemeWidget.data;

      expect(newTheme, isNot(currentTheme));
    },
  );

  testWidgets(
    "Creates default theme data if nothing was specified",
    (WidgetTester tester) async {
      await tester.pumpWidget(const MetricsThemeBuilderTestbed());

      final themeWidget =
          tester.widget<MetricsThemeBuilder>(find.byType(MetricsThemeBuilder));

      expect(themeWidget.lightTheme, isA<LightMetricsThemeData>());
      expect(themeWidget.darkTheme, isA<DarkMetricsThemeData>());
    },
  );
}

class MetricsThemeBuilderTestbed extends StatelessWidget {
  final MetricsThemeData lightTheme;
  final MetricsThemeData darkTheme;
  final ThemeStore themeStore;

  const MetricsThemeBuilderTestbed({
    Key key,
    this.lightTheme,
    this.darkTheme,
    this.themeStore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Injector(
        inject: [Inject<ThemeStore>(() => themeStore ?? ThemeStore())],
        initState: _initThemeState,
        builder: (context) {
          return MetricsThemeBuilder(
            lightTheme: lightTheme,
            darkTheme: darkTheme,
            child: Container(),
          );
        },
      ),
    );
  }

  void _initThemeState() {
    Injector.getAsReactive<ThemeStore>()
        .setState((model) => model.isDark = false);
  }
}
