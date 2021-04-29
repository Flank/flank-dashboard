// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/graphs/circle_percentage.dart';
import 'package:metrics/base/presentation/widgets/scorecard.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_table/theme_data/project_metrics_table_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_table/theme_data/project_metrics_tile_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/dashboard/presentation/view_models/build_number_scorecard_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_metric_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/coverage_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/performance_sparkline_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/project_metrics_tile_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/stability_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_results_metric_graph.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table_row.dart';
import 'package:metrics/dashboard/presentation/widgets/performance_sparkline_graph.dart';
import 'package:metrics/dashboard/presentation/widgets/project_build_status.dart';
import 'package:metrics/dashboard/presentation/widgets/project_metrics_tile.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/project_build_status_style_strategy.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../test_utils/dimensions_util.dart';
import '../../../test_utils/metrics_themed_testbed.dart';
import '../../../test_utils/test_injection_container.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("ProjectMetricsTile", () {
    setUpAll(() {
      DimensionsUtil.setTestWindowSize(width: DimensionsConfig.contentWidth);
    });

    tearDownAll(() {
      DimensionsUtil.clearTestWindowSize();
    });

    final ProjectMetricsTileViewModel testProjectMetrics =
        ProjectMetricsTileViewModel(
      projectName: 'Test project name',
      coverage: const CoverageViewModel(value: 0.3),
      stability: const StabilityViewModel(value: 0.4),
      buildNumberMetric: const BuildNumberScorecardViewModel(numberOfBuilds: 3),
      performanceSparkline: PerformanceSparklineViewModel(
        performance: UnmodifiableListView([]),
      ),
      buildResultMetrics: BuildResultMetricViewModel(
        buildResults: UnmodifiableListView([]),
      ),
    );

    const backgroundColor = Colors.black;
    const hoverBackgroundColor = Colors.grey;
    const borderColor = Colors.black;
    const hoverBorderColor = Colors.yellow;
    const textStyle = TextStyle(color: Colors.red);

    const themeData = MetricsThemeData(
      projectMetricsTableTheme: ProjectMetricsTableThemeData(
        projectMetricsTileTheme: ProjectMetricsTileThemeData(
          backgroundColor: backgroundColor,
          hoverBackgroundColor: hoverBackgroundColor,
          borderColor: borderColor,
          hoverBorderColor: hoverBorderColor,
          textStyle: textStyle,
        ),
      ),
    );

    Future<void> _hoverMetricsTile(WidgetTester tester) async {
      final tappableAreaFinder = find.byType(TappableArea);
      final mouseRegionFinder = find.byType(MouseRegion);

      final mouseRegion = tester.widget<MouseRegion>(
        find.descendant(of: tappableAreaFinder, matching: mouseRegionFinder),
      );

      const pointerEvent = PointerEnterEvent();
      mouseRegion.onEnter(pointerEvent);

      await tester.pump();
    }

    testWidgets(
      "throws an AssertionError if a project metrics parameter is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _ProjectMetricsTileTestbed(
          projectMetrics: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "applies the background color from the metrics theme when the tile is not hovered",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_ProjectMetricsTileTestbed(
            themeData: themeData,
            projectMetrics: testProjectMetrics,
          ));
        });

        final projectMetricsTileContainer = tester.widget<DecoratedBox>(
          find.ancestor(
            of: find.byType(MetricsTableRow),
            matching: find.byType(DecoratedBox),
          ),
        );

        final decoration =
            projectMetricsTileContainer.decoration as BoxDecoration;

        expect(decoration.color, equals(backgroundColor));
      },
    );

    testWidgets(
      "applies the hover background color from the metrics theme when the tile is hovered",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_ProjectMetricsTileTestbed(
            themeData: themeData,
            projectMetrics: testProjectMetrics,
          ));
        });

        await _hoverMetricsTile(tester);

        final projectMetricsTileContainer = tester.widget<DecoratedBox>(
          find.ancestor(
            of: find.byType(MetricsTableRow),
            matching: find.byType(DecoratedBox),
          ),
        );

        final decoration =
            projectMetricsTileContainer.decoration as BoxDecoration;

        expect(decoration.color, equals(hoverBackgroundColor));
      },
    );

    testWidgets(
      "applies the border color from the metrics theme when the tile is not hovered",
      (WidgetTester tester) async {
        await tester.pumpWidget(_ProjectMetricsTileTestbed(
          themeData: themeData,
          projectMetrics: testProjectMetrics,
        ));

        final projectMetricsTileContainer = tester.widget<DecoratedBox>(
          find.ancestor(
            of: find.byType(MetricsTableRow),
            matching: find.byType(DecoratedBox),
          ),
        );

        final decoration =
            projectMetricsTileContainer.decoration as BoxDecoration;
        final border = decoration.border as Border;

        expect(border.top.color, equals(borderColor));
        expect(border.bottom.color, equals(borderColor));
        expect(border.left.color, equals(borderColor));
        expect(border.right.color, equals(borderColor));
      },
    );

    testWidgets(
      "applies the hover border color from the metrics theme when the tile is hovered",
      (WidgetTester tester) async {
        await tester.pumpWidget(_ProjectMetricsTileTestbed(
          themeData: themeData,
          projectMetrics: testProjectMetrics,
        ));

        await _hoverMetricsTile(tester);

        final projectMetricsTileContainer = tester.widget<DecoratedBox>(
          find.ancestor(
            of: find.byType(MetricsTableRow),
            matching: find.byType(DecoratedBox),
          ),
        );

        final decoration =
            projectMetricsTileContainer.decoration as BoxDecoration;
        final border = decoration.border as Border;

        expect(border.top.color, equals(hoverBorderColor));
        expect(border.bottom.color, equals(hoverBorderColor));
        expect(border.left.color, equals(hoverBorderColor));
        expect(border.right.color, equals(hoverBorderColor));
      },
    );

    testWidgets(
      "applies the text style from the metrics theme",
      (WidgetTester tester) async {
        const projectName = 'projectName';
        const tileViewModel = ProjectMetricsTileViewModel(
          projectName: projectName,
        );

        await tester.pumpWidget(const _ProjectMetricsTileTestbed(
          themeData: themeData,
          projectMetrics: tileViewModel,
        ));

        final projectNameText = tester.widget<Text>(
          find.text(projectName),
        );

        expect(projectNameText.style, equals(textStyle));
      },
    );

    testWidgets(
      "displays the project name even if it is very long",
      (WidgetTester tester) async {
        const ProjectMetricsTileViewModel metrics = ProjectMetricsTileViewModel(
          projectName:
              'Some very long name to display that may overflow on some screens but should be displayed properly. Also, this project name has a description that placed to the project name, but we still can display it properly with any overflows.',
        );

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _ProjectMetricsTileTestbed(
            projectMetrics: metrics,
          ));
        });

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      "displays the ProjectMetricsData even when the project name is null",
      (WidgetTester tester) async {
        const metrics = ProjectMetricsTileViewModel();

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _ProjectMetricsTileTestbed(
            projectMetrics: metrics,
          ));
        });

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      "contains coverage circle percentage",
      (WidgetTester tester) async {
        final coveragePercent = testProjectMetrics.coverage;
        final coverageText = '${(coveragePercent.value * 100).toInt()}%';

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_ProjectMetricsTileTestbed(
            projectMetrics: testProjectMetrics,
          ));
        });
        await tester.pumpAndSettle();

        expect(
          find.widgetWithText(CirclePercentage, coverageText),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "contains stability circle percentage",
      (WidgetTester tester) async {
        final stabilityPercent = testProjectMetrics.coverage;
        final stabilityText = '${(stabilityPercent.value * 100).toInt()}%';

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_ProjectMetricsTileTestbed(
            projectMetrics: testProjectMetrics,
          ));
        });
        await tester.pumpAndSettle();

        expect(
          find.widgetWithText(CirclePercentage, stabilityText),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "contains Scorecard with build number metric",
      (WidgetTester tester) async {
        final numberOfBuilds =
            testProjectMetrics.buildNumberMetric.numberOfBuilds;

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_ProjectMetricsTileTestbed(
            projectMetrics: testProjectMetrics,
          ));
        });

        expect(
          find.widgetWithText(Scorecard, '$numberOfBuilds'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "contains SparklineGraph widgets with performance metric",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_ProjectMetricsTileTestbed(
            projectMetrics: testProjectMetrics,
          ));
        });

        expect(
          find.byType(PerformanceSparklineGraph),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "contains the bar results metric graph with the build results",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_ProjectMetricsTileTestbed(
            projectMetrics: testProjectMetrics,
          ));
        });

        expect(find.byType(BuildResultsMetricGraph), findsOneWidget);
      },
    );

    testWidgets(
      "displays ProjectBuildStatus widget with the ProjectBuildStatusStyleStrategy",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_ProjectMetricsTileTestbed(
            projectMetrics: testProjectMetrics,
          ));
        });

        final projectBuildStatus = tester.widget<ProjectBuildStatus>(
          find.byType(ProjectBuildStatus),
        );

        expect(
          projectBuildStatus.buildStatusStyleStrategy,
          isA<ProjectBuildStatusStyleStrategy>(),
        );
      },
    );
  });
}

/// A testbed class required to test the [ProjectMetricsTile] widget.
class _ProjectMetricsTileTestbed extends StatelessWidget {
  /// The [ProjectMetricsTileViewModel] instance to display.
  final ProjectMetricsTileViewModel projectMetrics;

  /// A [MetricsThemeData] used in tests.
  final MetricsThemeData themeData;

  /// Creates an instance of this testbed
  /// with the given [projectMetrics] and [themeData].
  ///
  /// If the [themeData] is not specified, the [MetricsThemeData] used.
  const _ProjectMetricsTileTestbed({
    Key key,
    this.projectMetrics,
    this.themeData = const MetricsThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      child: MetricsThemedTestbed(
        metricsThemeData: themeData,
        body: ProjectMetricsTile(
          projectMetricsViewModel: projectMetrics,
        ),
      ),
    );
  }
}
