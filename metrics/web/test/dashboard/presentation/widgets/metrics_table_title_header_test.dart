import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_table/theme_data/metrics_table_header_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_table/theme_data/project_metrics_table_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table_row.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table_title_header.dart';

import '../../../test_utils/dimensions_util.dart';
import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("MetricsTableTitleHeader", () {
    setUpAll(() {
      DimensionsUtil.setTestWindowSize(width: DimensionsConfig.contentWidth);
    });

    tearDownAll(() {
      DimensionsUtil.clearTestWindowSize();
    });

    testWidgets(
      "applies the text style from the metrics theme",
      (tester) async {
        const expectedTextStyle = TextStyle(color: Colors.red, inherit: false);

        const themeData = MetricsThemeData(
          projectMetricsTableTheme: ProjectMetricsTableThemeData(
            metricsTableHeaderTheme: MetricsTableHeaderThemeData(
              textStyle: expectedTextStyle,
            ),
          ),
        );

        await tester.pumpWidget(
          const _MetricsTableTitleHeaderTestbed(
            metricsThemeData: themeData,
          ),
        );

        final defaultTextStyle = tester.widget<DefaultTextStyle>(
          find.descendant(
            of: find.byType(MetricsTableTitleHeader),
            matching: find.byType(DefaultTextStyle),
          ),
        );
        final textStyle = defaultTextStyle.style;

        expect(textStyle, equals(expectedTextStyle));
      },
    );

    testWidgets(
      "applies an empty container to the build status",
      (tester) async {
        await tester.pumpWidget(const _MetricsTableTitleHeaderTestbed());

        final metricsTableRowWidget = tester.widget<MetricsTableRow>(
          find.byType(MetricsTableRow),
        );

        expect(metricsTableRowWidget.status, isA<Container>());
      },
    );

    testWidgets(
      "applies an empty container to the project name",
      (tester) async {
        await tester.pumpWidget(const _MetricsTableTitleHeaderTestbed());

        final metricsTableRowWidget = tester.widget<MetricsTableRow>(
          find.byType(MetricsTableRow),
        );

        expect(metricsTableRowWidget.name, isA<Container>());
      },
    );

    testWidgets(
      "displays the performance header",
      (tester) async {
        await tester.pumpWidget(const _MetricsTableTitleHeaderTestbed());

        expect(find.text(DashboardStrings.performance), findsOneWidget);
      },
    );

    testWidgets(
      "displays the builds header",
      (tester) async {
        await tester.pumpWidget(const _MetricsTableTitleHeaderTestbed());

        expect(find.text(DashboardStrings.builds), findsOneWidget);
      },
    );

    testWidgets(
      "displays the stability header",
      (tester) async {
        await tester.pumpWidget(const _MetricsTableTitleHeaderTestbed());

        expect(find.text(DashboardStrings.stability), findsOneWidget);
      },
    );

    testWidgets(
      "displays the coverage header",
      (tester) async {
        await tester.pumpWidget(const _MetricsTableTitleHeaderTestbed());

        expect(find.text(DashboardStrings.coverage), findsOneWidget);
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
