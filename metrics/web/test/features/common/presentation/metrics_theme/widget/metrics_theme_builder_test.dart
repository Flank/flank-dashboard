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
    "Can't build the widget without builder",
    (WidgetTester tester) async {
      await tester.pumpWidget(const _MetricsThemeBuilderTestbed(builder: null));

      expect(tester.takeException(), isA<AssertionError>());
    },
  );

  testWidgets(
    "Changes the theme on store changing",
    (WidgetTester tester) async {
      final store = ThemeStore();

      await tester.pumpWidget(_MetricsThemeBuilderTestbed(
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
      await tester.pumpWidget(const _MetricsThemeBuilderTestbed());

      final themeWidget =
          tester.widget<MetricsThemeBuilder>(find.byType(MetricsThemeBuilder));

      expect(themeWidget.lightTheme, isA<LightMetricsThemeData>());
      expect(themeWidget.darkTheme, isA<DarkMetricsThemeData>());
    },
  );
}

class _MetricsThemeBuilderTestbed extends StatelessWidget {
  final MetricsThemeData lightTheme;
  final MetricsThemeData darkTheme;
  final ThemeStore themeStore;
  final ThemeBuilder builder;

  const _MetricsThemeBuilderTestbed({
    Key key,
    this.lightTheme,
    this.darkTheme,
    this.themeStore,
    this.builder = _builder,
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
            builder: builder,
          );
        },
      ),
    );
  }

  static Widget _builder(BuildContext context, ThemeStore store) {
    return Container();
  }

  void _initThemeState() {
    Injector.getAsReactive<ThemeStore>()
        .setState((model) => model.isDark = false);
  }
}
