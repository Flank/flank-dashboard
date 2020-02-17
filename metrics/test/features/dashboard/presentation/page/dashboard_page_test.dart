import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/common/presentation/drawer/widget/metrics_drawer.dart';
import 'package:metrics/features/common/presentation/metrics_theme/store/theme_store.dart';
import 'package:metrics/features/common/presentation/metrics_theme/widgets/metrics_theme_builder.dart';
import 'package:metrics/features/dashboard/domain/entities/coverage.dart';
import 'package:metrics/features/dashboard/presentation/model/build_result_bar_data.dart';
import 'package:metrics/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:metrics/features/dashboard/presentation/state/project_metrics_store.dart';
import 'package:metrics/features/dashboard/presentation/widgets/circle_percentage.dart';
import 'package:metrics/features/dashboard/presentation/widgets/sparkline_graph.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

void main() {
  group("Dashboard configuration", () {
    testWidgets(
      "Contains Circle percentage with coverage and stability",
      (WidgetTester tester) async {
        await tester.pumpWidget(const DashboardTestbed());
        await tester.pumpAndSettle();
        expect(
          find.descendant(
              of: find.byType(CirclePercentage),
              matching: find.text('Coverage')),
          findsOneWidget,
        );
        expect(
          find.descendant(
              of: find.byType(CirclePercentage),
              matching: find.text('Stability')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Contains SparklineGraph widgets with performance and build metrics',
      (WidgetTester tester) async {
        await tester.pumpWidget(const DashboardTestbed());
        await tester.pumpAndSettle();
        expect(
          find.descendant(
            of: find.byType(SparklineGraph),
            matching: find.text('Performance'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byType(SparklineGraph),
            matching: find.text('Build'),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "Displays an error, occured during loading the metrics data",
      (WidgetTester tester) async {
        const metricsStore = MetricsStoreErrorStub();

        await tester.pumpWidget(const DashboardTestbed(
          metricsStore: metricsStore,
        ));

        await tester.pumpAndSettle();

        expect(
          find.text(
              "An error occured during loading: ${MetricsStoreErrorStub.errorMessage}"),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "Displays the drawer on tap on menu button",
      (WidgetTester tester) async {
        await tester.pumpWidget(const DashboardTestbed());
        await tester.pumpAndSettle();

        await tester.tap(find.descendant(
          of: find.byType(AppBar),
          matching: find.byType(IconButton),
        ));
        await tester.pumpAndSettle();

        expect(find.byType(MetricsDrawer), findsOneWidget);
      },
    );

    testWidgets(
      "Changes the widget theme on switching to dark theme in drawer",
      (WidgetTester tester) async {
        final themeStore = ThemeStore();

        await tester.pumpWidget(DashboardTestbed(
          themeStore: themeStore,
        ));
        await tester.pumpAndSettle();

        final circlePercentageValueColor =
            _getCirclePercentageValueColor(tester);

        await tester.tap(find.descendant(
          of: find.byType(AppBar),
          matching: find.byType(IconButton),
        ));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(CheckboxListTile));
        await tester.pump();

        final newCirclePercentageValueColor =
            _getCirclePercentageValueColor(tester);

        expect(
          newCirclePercentageValueColor,
          isNot(circlePercentageValueColor),
        );
      },
    );
  });
}

Color _getCirclePercentageValueColor(WidgetTester tester) {
  final circlePercentageFinder = find.descendant(
    of: find.widgetWithText(CirclePercentage, "Coverage"),
    matching: find.byType(CustomPaint),
  );

  final customPaintWidget = tester.widget<CustomPaint>(
    circlePercentageFinder,
  );

  final painter = customPaintWidget.painter as CirclePercentageChartPainter;

  return painter.valueColor;
}

class DashboardTestbed extends StatelessWidget {
  final ProjectMetricsStore metricsStore;
  final ThemeStore themeStore;

  const DashboardTestbed({
    Key key,
    this.metricsStore = const MetricsStoreStub(),
    this.themeStore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Injector(
        inject: [
          Inject<ProjectMetricsStore>(() => metricsStore),
          Inject<ThemeStore>(() => themeStore ?? ThemeStore()),
        ],
        initState: () {
          Injector.getAsReactive<ProjectMetricsStore>()
              .setState((store) => store.getCoverage('projectId'));
          Injector.getAsReactive<ThemeStore>()
              .setState((store) => store.isDark = false);
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

class MetricsStoreStub implements ProjectMetricsStore {
  const MetricsStoreStub();

  @override
  Coverage get coverage => const Coverage(percent: 0.3);

  @override
  Future<void> getCoverage(String projectId) async {}

  @override
  int get averageBuildTime => 20;

  @override
  Future getBuildMetrics(String projectId) async {}

  @override
  int get totalBuildNumber => null;

  @override
  List<Point<int>> get projectBuildNumberMetrics => [];

  @override
  List<BuildResultBarData> get projectBuildResultMetrics => [];

  @override
  List<Point<int>> get projectPerformanceMetrics => [];
}

class MetricsStoreErrorStub extends MetricsStoreStub {
  static const String errorMessage = "Unknown error";

  const MetricsStoreErrorStub();

  @override
  Future<void> getCoverage(String projectId) async {
    throw errorMessage;
  }

  @override
  Future getBuildMetrics(String projectId) async {
    throw errorMessage;
  }
}
