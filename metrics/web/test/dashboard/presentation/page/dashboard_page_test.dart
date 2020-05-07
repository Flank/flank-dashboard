import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/app_bar/widget/metrics_app_bar.dart';
import 'package:metrics/common/presentation/drawer/widget/metrics_drawer.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme_builder.dart';
import 'package:metrics/dashboard/presentation/pages/dashboard_page.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:metrics/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/dashboard/presentation/widgets/build_number_text_metric.dart';
import 'package:mockito/mockito.dart';

import '../../../test_utils/project_metrics_notifier_mock.dart';
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
        final themeStore = ThemeNotifier();

        await tester.pumpWidget(_DashboardTestbed(
          themeNotifier: themeStore,
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

    testWidgets(
      "subscribes to project updates in intiState",
      (tester) async {
        final metricsNotifier = ProjectMetricsNotifierMock();

        await tester.pumpWidget(_DashboardTestbed(
          metricsNotifier: metricsNotifier,
        ));

        verify(metricsNotifier.subscribeToProjects()).called(equals(1));
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

/// A testbed widget, used to test the [DashboardPage] widget.
class _DashboardTestbed extends StatelessWidget {
  /// The [ThemeNotifier] that will be injected and used to test the [DashboardPage].
  final ThemeNotifier themeNotifier;
  final ProjectMetricsNotifier metricsNotifier;

  /// Creates the [_DashboardTestbed] with the given [themeNotifier].
  const _DashboardTestbed({
    Key key,
    this.themeNotifier,
    this.metricsNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      themeNotifier: themeNotifier,
      metricsNotifier: metricsNotifier,
      child: MaterialApp(
        home: MetricsThemeBuilder(
          builder: (_, __) {
            return DashboardPage();
          },
        ),
      ),
    );
  }
}
