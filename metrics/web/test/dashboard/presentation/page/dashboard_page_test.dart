import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/common/presentation/app_bar/widget/metrics_app_bar.dart';
import 'package:metrics/common/presentation/drawer/widget/metrics_drawer.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme_builder.dart';
import 'package:metrics/common/presentation/routes/route_generator.dart';
import 'package:metrics/dashboard/presentation/pages/dashboard_page.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:metrics/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/dashboard/presentation/widgets/build_number_text_metric.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table.dart';
import 'package:provider/provider.dart';

import '../../../test_utils/test_injection_container.dart';

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

        expect(find.byType(MetricsTable), findsOneWidget);
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
        final themeNotifier = ThemeNotifier();

        await tester.pumpWidget(_DashboardTestbed(
          themeNotifier: themeNotifier,
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

//    testWidgets(
//      ".dispose() unsubscribes from projects",
//      (tester) async {
//        final metricsNotifier = ProjectMetricsNotifierMock();
//        final authNotifier = SignedInAuthNotifierStub();
//
//        when(metricsNotifier.projectsMetrics).thenReturn([]);
//
//        await tester.pumpWidget(_DashboardTestbed(
//          metricsNotifier: metricsNotifier,
//          authNotifier: authNotifier,
//        ));
//
//        await tester.tap(find.descendant(
//          of: find.byType(MetricsAppBar),
//          matching: find.byType(IconButton),
//        ));
//        await tester.pumpAndSettle();
//
//        await tester.tap(find.text(CommonStrings.logOut));
//        await tester.pumpAndSettle();
//
//        expect(find.byType(DashboardPage), findsNothing);
//        verify(metricsNotifier.unsubscribeFromProjects()).called(equals(1));
//      },
//    );

//    testWidgets(
//      "subscribes to project updates in initState",
//      (tester) async {
//        final metricsNotifier = ProjectMetricsNotifierMock();
//
//        await tester.pumpWidget(_DashboardTestbed(
//          metricsNotifier: metricsNotifier,
//        ));
//
//        verify(metricsNotifier.subscribeToProjects()).called(equals(1));
//      },
//    );
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

/// A testbed widget, used to test the [DashboardPage] widget.
class _DashboardTestbed extends StatelessWidget {
  /// The [ThemeNotifier] to inject and use to test the [DashboardPage].
  final ThemeNotifier themeNotifier;

  /// The [ProjectMetricsNotifier] to inject and use to test the [DashboardPage].
  final ProjectMetricsNotifier metricsNotifier;

  /// The [AuthNotifier] to inject and use to test the [DashboardPage].
  final AuthNotifier authNotifier;

  /// Creates the [_DashboardTestbed] with the given [themeNotifier].
  const _DashboardTestbed({
    Key key,
    this.themeNotifier,
    this.metricsNotifier,
    this.authNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      themeNotifier: themeNotifier,
      metricsNotifier: metricsNotifier,
      authNotifier: authNotifier,
      child: Builder(builder: (context) {
        return MaterialApp(
          onGenerateRoute: (settings) => RouteGenerator.generateRoute(
              settings: settings,
              isLoggedIn:
                  Provider.of<AuthNotifier>(context, listen: false).isLoggedIn),
          home: MetricsThemeBuilder(
            builder: (_, __) {
              return DashboardPage();
            },
          ),
        );
      }),
    );
  }
}
