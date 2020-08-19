import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_table/theme_data/project_metrics_table_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_table/theme_data/project_metrics_tile_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/text_placeholder/theme/theme_data/text_placeholder_theme_data.dart';
import 'package:metrics/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/dashboard/presentation/widgets/no_search_results_placeholder.dart';

import '../../../test_utils/finder_util.dart';
import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  const backgroundColor = Colors.red;
  const textStyle = TextStyle(color: Colors.red);

  const metricsThemeData = MetricsThemeData(
    projectMetricsTableTheme: ProjectMetricsTableThemeData(
      projectMetricsTileTheme: ProjectMetricsTileThemeData(
        backgroundColor: backgroundColor,
        textStyle: textStyle,
      ),
    ),
    textPlaceholderTheme: TextPlaceholderThemeData(
      textStyle: textStyle,
    ),
  );

  group("NoSearchResultsPlaceholder", () {
    testWidgets(
      "displays the no search results placeholder",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _NoSearchResultsPlaceholderTestbed());

        expect(find.text(DashboardStrings.noSearchResults), findsOneWidget);
      },
    );

    testWidgets(
      "applies the background color from the metrics theme",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _NoSearchResultsPlaceholderTestbed(
            metricsThemeData: metricsThemeData,
          ),
        );

        final decoration = FinderUtil.findBoxDecoration(tester);

        expect(decoration.color, equals(backgroundColor));
      },
    );

    testWidgets(
      "applies the text style from the metrics theme",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _NoSearchResultsPlaceholderTestbed(
            metricsThemeData: metricsThemeData,
          ),
        );

        final text = tester.firstWidget<Text>(
          find.text(DashboardStrings.noSearchResults),
        );

        expect(text.style, equals(textStyle));
      },
    );
  });
}

/// A testbed class required to test the [NoSearchResultsPlaceholder] widget.
class _NoSearchResultsPlaceholderTestbed extends StatelessWidget {
  /// A [MetricsThemeData] used in tests.
  final MetricsThemeData metricsThemeData;

  /// Creates an instance of the placeholder testbed with
  /// the given [metricsThemeData].
  ///
  /// The [metricsThemeData] defaults to an empty [MetricsThemeData].
  const _NoSearchResultsPlaceholderTestbed({
    Key key,
    this.metricsThemeData = const MetricsThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: metricsThemeData,
      body: const NoSearchResultsPlaceholder(),
    );
  }
}
