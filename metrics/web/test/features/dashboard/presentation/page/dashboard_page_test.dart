import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/common/presentation/drawer/widget/metrics_drawer.dart';
import 'package:metrics/features/common/presentation/metrics_theme/store/theme_store.dart';
import 'package:metrics/features/common/presentation/metrics_theme/widgets/metrics_theme_builder.dart';
import 'package:metrics/features/dashboard/presentation/model/project_metrics_data.dart';
import 'package:metrics/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:metrics/features/dashboard/presentation/state/project_metrics_store.dart';
import 'package:metrics/features/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/features/dashboard/presentation/widgets/build_number_text_metric.dart';
import 'package:metrics/features/dashboard/presentation/widgets/circle_percentage.dart';
import 'package:metrics/features/dashboard/presentation/widgets/metrics_title.dart';
import 'package:metrics/features/dashboard/presentation/widgets/sparkline_graph.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

void main() {
  group("DashboardPage", () {
    testWidgets(
      "displays the DashboardTitle at the bottom of the AppBar",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _DashboardTestbed());

        expect(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.byType(MetricsTitle),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "displays an error, occured during loading the metrics data",
      (WidgetTester tester) async {
        const metricsStore = _MetricsStoreErrorStub();

        await tester.pumpWidget(const _DashboardTestbed(
          metricsStore: metricsStore,
        ));

        await tester.pumpAndSettle();

        expect(
          find.text(DashboardStrings.getLoadingErrorMessage(
              '${_MetricsStoreErrorStub.errorMessage}')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "displays the drawer on tap on menu button",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _DashboardTestbed());
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
      "changes the widget theme on switching theme in the drawer",
      (WidgetTester tester) async {
        final themeStore = ThemeStore();

        await tester.pumpWidget(_DashboardTestbed(
          themeStore: themeStore,
        ));
        await tester.pumpAndSettle();

        final darkBuildNumberMetricColor = _getBuildNumberMetricColor(tester);

        await tester.tap(find.descendant(
          of: find.byType(AppBar),
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
      'displays the placeholder when there are no available projects',
      (WidgetTester tester) async {
        const metricsStore = _MetricsStoreStub(projectMetrics: []);
        await tester.pumpWidget(const _DashboardTestbed(
          metricsStore: metricsStore,
        ));

        await tester.pumpAndSettle();

        expect(
          find.text(DashboardStrings.noConfiguredProjects),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "displays performance title above the sparkline graph widget",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _DashboardTestbed());
        await tester.pumpAndSettle();

        final performanceMetricWidgetCenter = tester.getCenter(
          find.byType(SparklineGraph),
        );

        final performanceTitleCenter = tester.getCenter(
          find.descendant(
              of: find.byType(Expanded),
              matching: find.text(DashboardStrings.performance)),
        );

        expect(performanceMetricWidgetCenter.dx, performanceTitleCenter.dx);
      },
    );

    testWidgets(
      "displays builds title above the build number text metric widget",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _DashboardTestbed());
        await tester.pumpAndSettle();

        final performanceMetricWidgetCenter = tester.getCenter(
          find.byType(BuildNumberTextMetric),
        );

        final performanceTitleCenter = tester.getCenter(
          find.descendant(
              of: find.byType(Expanded),
              matching: find.text(DashboardStrings.builds)),
        );

        expect(performanceMetricWidgetCenter.dx, performanceTitleCenter.dx);
      },
    );

    testWidgets(
      "displays stability title above the stability circle percentage widget",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _DashboardTestbed());
        await tester.pumpAndSettle();
        final stabilityPercent = _MetricsStoreStub.testProjectMetrics.stability;
        final stabilityText = '${(stabilityPercent.value * 100).toInt()}%';

        final performanceMetricWidgetCenter = tester.getCenter(
          find.widgetWithText(CirclePercentage, stabilityText),
        );

        final performanceTitleCenter = tester.getCenter(
          find.descendant(
              of: find.byType(Expanded),
              matching: find.text(DashboardStrings.stability)),
        );

        expect(performanceMetricWidgetCenter.dx, performanceTitleCenter.dx);
      },
    );

    testWidgets(
      "displays stability title above the stability circle percentage widget",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _DashboardTestbed());
        await tester.pumpAndSettle();
        final coveragePercent = _MetricsStoreStub.testProjectMetrics.coverage;
        final coverageText = '${(coveragePercent.value * 100).toInt()}%';

        final performanceMetricWidgetCenter = tester.getCenter(
          find.widgetWithText(CirclePercentage, coverageText),
        );

        final performanceTitleCenter = tester.getCenter(
          find.descendant(
              of: find.byType(Expanded),
              matching: find.text(DashboardStrings.coverage)),
        );

        expect(performanceMetricWidgetCenter.dx, performanceTitleCenter.dx);
      },
    );
  });
}

Color _getBuildNumberMetricColor(WidgetTester tester) {
  final buildNumberTextWidget = tester.widget<Text>(
    find.descendant(
      of: find.byType(BuildNumberTextMetric),
      matching: find.text('0'),
    ),
  );

  return buildNumberTextWidget.style.color;
}

class _DashboardTestbed extends StatelessWidget {
  final ProjectMetricsStore metricsStore;
  final ThemeStore themeStore;

  const _DashboardTestbed({
    Key key,
    this.metricsStore = const _MetricsStoreStub(),
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
          Injector.getAsReactive<ProjectMetricsStore>().setState(
            (store) => store.subscribeToProjects(),
            catchError: true,
          );
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

class _MetricsStoreStub implements ProjectMetricsStore {
  static const testProjectMetrics = ProjectMetricsData(
    projectId: '1',
    projectName: 'project',
    coverage: Percent(0.1),
    stability: Percent(0.2),
    buildNumberMetric: 0,
    averageBuildDurationInMinutes: 1,
    performanceMetrics: [],
    buildResultMetrics: [],
  );

  final List<ProjectMetricsData> projectMetrics;

  const _MetricsStoreStub({
    this.projectMetrics = const [testProjectMetrics],
  });

  @override
  Stream<List<ProjectMetricsData>> get projectsMetrics =>
      Stream.value(projectMetrics);

  @override
  Future<void> subscribeToProjects() async {}

  @override
  void dispose() {}
}

class _MetricsStoreErrorStub extends _MetricsStoreStub {
  static const String errorMessage = "Unknown error";

  const _MetricsStoreErrorStub();

  @override
  Stream<List<ProjectMetricsData>> get projectsMetrics => throw errorMessage;

  @override
  Future<void> subscribeToProjects() {
    throw errorMessage;
  }

  @override
  void dispose() {}
}
