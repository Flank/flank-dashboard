// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/widgets/tooltip_title.dart';
import 'package:metrics/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table_row.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table_title_header.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../test_utils/dimensions_util.dart';
import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("MetricsTableTitleHeader", () {
    const src = 'icons/info.svg';
    final lastBuildsFinder = find.widgetWithText(
      TooltipTitle,
      DashboardStrings.lastBuilds,
    );
    final performanceFinder = find.widgetWithText(
      TooltipTitle,
      DashboardStrings.performance,
    );
    final buildsFinder = find.widgetWithText(
      TooltipTitle,
      DashboardStrings.builds,
    );
    final stabilityFinder = find.widgetWithText(
      TooltipTitle,
      DashboardStrings.stability,
    );
    final coverageFinder = find.widgetWithText(
      TooltipTitle,
      DashboardStrings.coverage,
    );

    setUpAll(() {
      DimensionsUtil.setTestWindowSize(width: DimensionsConfig.contentWidth);
    });

    tearDownAll(() {
      DimensionsUtil.clearTestWindowSize();
    });

    testWidgets(
      "applies an empty container to the build status",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsTableTitleHeaderTestbed());
        });

        final metricsTableRowWidget = tester.widget<MetricsTableRow>(
          find.byType(MetricsTableRow),
        );

        expect(metricsTableRowWidget.status, isA<Container>());
      },
    );

    testWidgets(
      "applies an empty container to the project name",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsTableTitleHeaderTestbed());
        });

        final metricsTableRowWidget = tester.widget<MetricsTableRow>(
          find.byType(MetricsTableRow),
        );

        expect(metricsTableRowWidget.name, isA<Container>());
      },
    );

    testWidgets("displays the last builds tooltip title", (tester) async {
      await mockNetworkImagesFor(() {
        return tester.pumpWidget(const _MetricsTableTitleHeaderTestbed());
      });

      expect(lastBuildsFinder, findsOneWidget);
    });

    testWidgets(
      "applies the last builds description to the last builds tooltip title",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsTableTitleHeaderTestbed());
        });

        final tooltipTitle = tester.widget<TooltipTitle>(lastBuildsFinder);
        final tooltip = tooltipTitle.tooltip;

        expect(tooltip, equals(DashboardStrings.lastBuildsDescription));
      },
    );

    testWidgets(
      "applies the tooltip icon src to the last builds tooltip title",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsTableTitleHeaderTestbed());
        });

        final tooltipTitle = tester.widget<TooltipTitle>(lastBuildsFinder);

        expect(tooltipTitle.src, equals(src));
      },
    );

    testWidgets(
      "displays the performance tooltip title",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsTableTitleHeaderTestbed());
        });

        expect(performanceFinder, findsOneWidget);
      },
    );

    testWidgets(
      "applies the performance description to the performance tooltip title",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsTableTitleHeaderTestbed());
        });

        final tooltipTitle = tester.widget<TooltipTitle>(performanceFinder);
        final tooltip = tooltipTitle.tooltip;

        expect(tooltip, equals(DashboardStrings.performanceDescription));
      },
    );

    testWidgets(
      "applies the tooltip icon src to the performance tooltip title",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsTableTitleHeaderTestbed());
        });

        final tooltipTitle = tester.widget<TooltipTitle>(performanceFinder);

        expect(tooltipTitle.src, equals(src));
      },
    );

    testWidgets(
      "displays the builds tooltip title",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsTableTitleHeaderTestbed());
        });

        expect(buildsFinder, findsOneWidget);
      },
    );

    testWidgets(
      "applies the builds description to the builds tooltip title",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsTableTitleHeaderTestbed());
        });

        final tooltipTitle = tester.widget<TooltipTitle>(buildsFinder);
        final tooltip = tooltipTitle.tooltip;

        expect(tooltip, equals(DashboardStrings.buildsDescription));
      },
    );

    testWidgets(
      "applies the tooltip icon src to the builds tooltip title",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsTableTitleHeaderTestbed());
        });

        final tooltipTitle = tester.widget<TooltipTitle>(buildsFinder);

        expect(tooltipTitle.src, equals(src));
      },
    );

    testWidgets(
      "displays the stability tooltip title",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsTableTitleHeaderTestbed());
        });

        expect(stabilityFinder, findsOneWidget);
      },
    );

    testWidgets(
      "applies the stability description to the stability tooltip title",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsTableTitleHeaderTestbed());
        });

        final tooltipTitle = tester.widget<TooltipTitle>(stabilityFinder);
        final tooltip = tooltipTitle.tooltip;

        expect(tooltip, equals(DashboardStrings.stabilityDescription));
      },
    );

    testWidgets(
      "applies the tooltip icon src to the stability tooltip title",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsTableTitleHeaderTestbed());
        });

        final tooltipTitle = tester.widget<TooltipTitle>(stabilityFinder);

        expect(tooltipTitle.src, equals(src));
      },
    );

    testWidgets(
      "displays the coverage tooltip title",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsTableTitleHeaderTestbed());
        });

        expect(coverageFinder, findsOneWidget);
      },
    );

    testWidgets(
      "applies the coverage description to the coverage tooltip title",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsTableTitleHeaderTestbed());
        });

        final tooltipTitle = tester.widget<TooltipTitle>(coverageFinder);
        final tooltip = tooltipTitle.tooltip;

        expect(tooltip, equals(DashboardStrings.coverageDescription));
      },
    );

    testWidgets(
      "applies the tooltip icon src to the coverage tooltip title",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsTableTitleHeaderTestbed());
        });

        final tooltipTitle = tester.widget<TooltipTitle>(coverageFinder);

        expect(tooltipTitle.src, equals(src));
      },
    );
  });
}

/// A testbed class required to test the [MetricsTableTitleHeader] widget.
class _MetricsTableTitleHeaderTestbed extends StatelessWidget {
  /// A [MetricsThemeData] used in tests.
  final MetricsThemeData metricsThemeData;

  /// Creates the metrics table title header testbed with the given
  /// [metricsThemeData].
  ///
  /// The [metricsThemeData] defaults to an empty [MetricsThemeData] instance.
  const _MetricsTableTitleHeaderTestbed({
    Key key,
    this.metricsThemeData = const MetricsThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: metricsThemeData,
      body: const MetricsTableTitleHeader(),
    );
  }
}
