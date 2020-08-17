import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_table/theme_data/metrics_table_header_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_table/theme_data/project_metrics_table_theme_data.dart';
import 'package:metrics/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table_header.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table_row.dart';

import '../../../test_utils/dimensions_util.dart';
import '../../../test_utils/metrics_themed_testbed.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("MetricsTableHeader", () {
    setUpAll(() {
      DimensionsUtil.setTestWindowSize(width: DimensionsConfig.contentWidth);
    });

    tearDownAll(() {
      DimensionsUtil.clearTestWindowSize();
    });

    testWidgets(
      "contains MetricsTableRow",
      (tester) async {
        await tester.pumpWidget(_DashboardTableHeaderTestbed());

        expect(find.byType(MetricsTableRow), findsOneWidget);
      },
    );

    testWidgets(
      "displays the performance header",
      (tester) async {
        await tester.pumpWidget(_DashboardTableHeaderTestbed());

        expect(find.text(DashboardStrings.performance), findsOneWidget);
      },
    );

    testWidgets(
      "displays the builds header",
      (tester) async {
        await tester.pumpWidget(_DashboardTableHeaderTestbed());

        expect(find.text(DashboardStrings.builds), findsOneWidget);
      },
    );

    testWidgets(
      "displays the stability header",
      (tester) async {
        await tester.pumpWidget(_DashboardTableHeaderTestbed());

        expect(find.text(DashboardStrings.stability), findsOneWidget);
      },
    );

    testWidgets(
      "displays the coverage header",
      (tester) async {
        await tester.pumpWidget(_DashboardTableHeaderTestbed());

        expect(find.text(DashboardStrings.coverage), findsOneWidget);
      },
    );

    testWidgets(
      "applies the given text style from the metrics theme with default font-family",
      (tester) async {
        const expectedTextStyle = TextStyle(color: Colors.red);
        const expectedFontFamily = 'Roboto';
        final key = GlobalKey();

        const themeData = MetricsThemeData(
          projectMetricsTableTheme: ProjectMetricsTableThemeData(
            metricsTableHeaderTheme:
                MetricsTableHeaderThemeData(textStyle: expectedTextStyle),
          ),
        );

        await tester.pumpWidget(
          _DashboardTableHeaderTestbed(
            key: key,
            metricsThemeData: themeData,
            themeData: ThemeData(fontFamily: expectedFontFamily),
          ),
        );

        final defaultTextStyle = tester.widget<DefaultTextStyle>(
          find.descendant(
            of: find.byType(MetricsTableHeader),
            matching: find.byType(DefaultTextStyle),
          ),
        );
        final fontFamily =
            Theme.of(key.currentContext).textTheme.bodyText1.fontFamily;
        final style = expectedTextStyle.copyWith(fontFamily: fontFamily);

        expect(style, equals(defaultTextStyle.style));
      },
    );
  });
}

/// A testbed class required to test the [MetricsTableHeader] widget.
class _DashboardTableHeaderTestbed extends StatelessWidget {
  /// A [MetricsThemeData] used in tests.
  final MetricsThemeData metricsThemeData;

  /// A [ThemeData] used in tests.
  final ThemeData themeData;

  /// Creates an instance of this testbed with the given [metricsThemeData].
  ///
  /// The [metricsThemeData] defaults to a [MetricsThemeData].
  const _DashboardTableHeaderTestbed({
    Key key,
    this.themeData,
    this.metricsThemeData = const MetricsThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: metricsThemeData,
      themeData: themeData,
      body: MetricsTableHeader(),
    );
  }
}
