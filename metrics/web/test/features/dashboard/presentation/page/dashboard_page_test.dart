import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/auth/presentation/state/auth_store.dart';
import 'package:metrics/features/common/presentation/app_bar/widget/metrics_app_bar.dart';
import 'package:metrics/features/common/presentation/drawer/widget/metrics_drawer.dart';
import 'package:metrics/features/common/presentation/metrics_theme/store/theme_store.dart';
import 'package:metrics/features/common/presentation/metrics_theme/widgets/metrics_theme_builder.dart';
import 'package:metrics/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:metrics/features/dashboard/presentation/state/project_metrics_store.dart';
import 'package:metrics/features/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/features/dashboard/presentation/widgets/build_number_text_metric.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../../../test_utils/project_metrics_store_stub.dart';
import '../../../../test_utils/signed_in_auth_store_fake.dart';

void main() {
  group("DashboardPage", () {
    testWidgets(
      "contains the MetricsAppBar widget",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _DashboardTestbed());

        expect(find.byType(MetricsAppBar), findsOneWidget);
      },
    );

    testWidgets(
      "contains the MetricsTable widget",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _DashboardTestbed());

        expect(find.byType(MetricsAppBar), findsOneWidget);
      },
    );

    testWidgets(
      "displays the MetricsDrawer on tap on the menu button",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _DashboardTestbed());
        await tester.pumpAndSettle();

        await tester.tap(find.descendant(
          of: find.byType(MetricsAppBar),
          matching: find.byType(IconButton),
        ));
        await tester.pumpAndSettle();

        expect(find.byType(MetricsDrawer), findsOneWidget);
      },
    );

    testWidgets(
      "changes the widget theme on switching theme in the drawer",
      (WidgetTester tester) async {
        final themeStore = ThemeStore();

        await tester.pumpWidget(_DashboardTestbed(
          themeStore: themeStore,
        ));
        await tester.pumpAndSettle();

        final darkBuildNumberMetricColor = _getBuildNumberMetricColor(tester);

        await tester.tap(find.descendant(
          of: find.byType(MetricsAppBar),
          matching: find.byType(IconButton),
        ));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(CheckboxListTile));
        await tester.pump();

        final lightBuildNumberMetricColor = _getBuildNumberMetricColor(tester);

        expect(
          darkBuildNumberMetricColor,
          isNot(lightBuildNumberMetricColor),
        );
      },
    );
  });
}

Color _getBuildNumberMetricColor(WidgetTester tester) {
  final buildNumberTextWidget = tester.widget<Text>(
    find.descendant(
      of: find.byType(BuildNumberTextMetric),
      matching: find.text(DashboardStrings.noDataPlaceholder),
    ),
  );

  return buildNumberTextWidget.style.color;
}

class _DashboardTestbed extends StatelessWidget {
  static const ProjectMetricsStore metricsStore = ProjectMetricsStoreStub();
  final ThemeStore themeStore;

  const _DashboardTestbed({
    Key key,
    this.themeStore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Injector(
        inject: [
          Inject<ProjectMetricsStore>(() => metricsStore),
          Inject<ThemeStore>(() => themeStore ?? ThemeStore()),
          Inject<AuthStore>(() => SignedInAuthStoreFake()),
        ],
        initState: () {
          Injector.getAsReactive<ProjectMetricsStore>().setState(
            (store) => store.subscribeToProjects(),
            catchError: true,
          );
          Injector.getAsReactive<ThemeStore>()
              .setState((store) => store.isDark = false);
          Injector.getAsReactive<AuthStore>()
              .setState((store) => store.subscribeToAuthenticationUpdates());
        },
        builder: (BuildContext context) => MetricsThemeBuilder(
          builder: (_, __) {
            return DashboardPage();
          },
        ),
      ),
    );
  }
}
