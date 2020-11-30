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

    testWidgets(
      "displays the TooltipTitle with the last builds title, last builds description and info src",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsTableTitleHeaderTestbed());
        });

        final finder =
            find.widgetWithText(TooltipTitle, DashboardStrings.lastBuilds);
        final tooltipTitle = tester.widget<TooltipTitle>(finder);
        final tooltip = tooltipTitle.tooltip;

        expect(finder, findsOneWidget);
        expect(tooltipTitle.src, equals(src));
        expect(tooltip, equals(DashboardStrings.lastBuildsDescription));
      },
    );

    testWidgets(
      "displays the TooltipTitle with the performance title, performance description and info src",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsTableTitleHeaderTestbed());
        });

        final finder =
            find.widgetWithText(TooltipTitle, DashboardStrings.performance);
        final tooltipTitle = tester.widget<TooltipTitle>(finder);
        final tooltip = tooltipTitle.tooltip;

        expect(finder, findsOneWidget);
        expect(tooltipTitle.src, equals(src));
        expect(tooltip, equals(DashboardStrings.performanceDescription));
      },
    );

    testWidgets(
      "displays the TooltipTitle with the builds title, builds description and info src",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsTableTitleHeaderTestbed());
        });

        final finder =
            find.widgetWithText(TooltipTitle, DashboardStrings.builds);
        final tooltipTitle = tester.widget<TooltipTitle>(finder);
        final tooltip = tooltipTitle.tooltip;

        expect(finder, findsOneWidget);
        expect(tooltipTitle.src, equals(src));
        expect(tooltip, equals(DashboardStrings.buildsDescription));
      },
    );

    testWidgets(
      "displays the TooltipTitle with the stability title, stability description and info src",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsTableTitleHeaderTestbed());
        });

        final finder =
            find.widgetWithText(TooltipTitle, DashboardStrings.stability);
        final tooltipTitle = tester.widget<TooltipTitle>(finder);
        final tooltip = tooltipTitle.tooltip;

        expect(finder, findsOneWidget);
        expect(tooltipTitle.src, equals(src));
        expect(tooltip, equals(DashboardStrings.stabilityDescription));
      },
    );

    testWidgets(
      "displays the TooltipTitle with the coverage title, coverage description and info src",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsTableTitleHeaderTestbed());
        });

        final finder =
            find.widgetWithText(TooltipTitle, DashboardStrings.coverage);
        final tooltipTitle = tester.widget<TooltipTitle>(finder);
        final tooltip = tooltipTitle.tooltip;

        expect(finder, findsOneWidget);
        expect(tooltipTitle.src, equals(src));
        expect(tooltip, equals(DashboardStrings.coverageDescription));
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
