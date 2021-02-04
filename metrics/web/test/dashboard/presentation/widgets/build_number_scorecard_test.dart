// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/scorecard.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/scorecard/theme_data/scorecard_theme_data.dart';
import 'package:metrics/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/dashboard/presentation/view_models/build_number_scorecard_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_number_scorecard.dart';
import 'package:metrics/dashboard/presentation/widgets/no_data_placeholder.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("BuildNumberScorecard", () {
    const numberOfBuilds = 3;
    const buildNumber = BuildNumberScorecardViewModel(
      numberOfBuilds: numberOfBuilds,
    );

    testWidgets(
      'displays the `no data placeholder` if the given build number metric is null',
      (tester) async {
        await tester.pumpWidget(const _BuildNumberScorecardTestbed(
          buildNumberViewModel: null,
        ));

        expect(find.byType(NoDataPlaceholder), findsOneWidget);
      },
    );

    testWidgets(
      'displays the `no data placeholder` if the given number of builds is equal to 0',
      (tester) async {
        await tester.pumpWidget(const _BuildNumberScorecardTestbed(
          buildNumberViewModel:
              BuildNumberScorecardViewModel(numberOfBuilds: 0),
        ));

        expect(find.byType(NoDataPlaceholder), findsOneWidget);
      },
    );

    testWidgets(
      "displays the Scorecard widget with the given number of builds as a value",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _BuildNumberScorecardTestbed(
          buildNumberViewModel: buildNumber,
        ));

        final scorecardWidget = tester.widget<Scorecard>(
          find.byType(Scorecard),
        );

        expect(scorecardWidget.value, equals('$numberOfBuilds'));
      },
    );

    testWidgets(
      "displays the Scorecard widget with the DashboardStrings.perWeek as a description",
      (tester) async {
        await tester.pumpWidget(const _BuildNumberScorecardTestbed(
          buildNumberViewModel: buildNumber,
        ));

        final scorecardWidget = tester.widget<Scorecard>(
          find.byType(Scorecard),
        );

        expect(scorecardWidget.description, equals(DashboardStrings.perWeek));
      },
    );

    testWidgets(
      "applies the value text style from the metrics theme",
      (WidgetTester tester) async {
        const textStyle = TextStyle(color: Colors.red);
        const theme = MetricsThemeData(
          buildNumberScorecardTheme: ScorecardThemeData(
            valueTextStyle: textStyle,
          ),
        );

        await tester.pumpWidget(const _BuildNumberScorecardTestbed(
          buildNumberViewModel: buildNumber,
          metricsThemeData: theme,
        ));

        final buildNumberMetricText = tester.widget<AutoSizeText>(
          find.widgetWithText(AutoSizeText, '$numberOfBuilds'),
        );

        expect(buildNumberMetricText.style, equals(textStyle));
      },
    );

    testWidgets(
      "applies the description text style from the metrics theme",
      (WidgetTester tester) async {
        const textStyle = TextStyle(color: Colors.red);
        const theme = MetricsThemeData(
          buildNumberScorecardTheme: ScorecardThemeData(
            descriptionTextStyle: textStyle,
          ),
        );

        await tester.pumpWidget(const _BuildNumberScorecardTestbed(
          buildNumberViewModel: buildNumber,
          metricsThemeData: theme,
        ));

        final buildNumberMetricText =
            tester.widget<Text>(find.text(DashboardStrings.perWeek));

        expect(buildNumberMetricText.style, equals(textStyle));
      },
    );
  });
}

/// A testbed class needed to test the [BuildNumberScorecard] widget.
class _BuildNumberScorecardTestbed extends StatelessWidget {
  /// A [BuildNumberScorecardViewModel] to display.
  final BuildNumberScorecardViewModel buildNumberViewModel;

  /// A [MetricsThemeData] to display.
  final MetricsThemeData metricsThemeData;

  /// Creates a new instance of this testbed.
  ///
  /// If the [buildNumberViewModel] is not specified,
  /// the [BuildNumberScorecardViewModel] empty constructor used.
  /// If the [metricsThemeData] is not specified,
  /// the [MetricsThemeData] empty constructor used.
  const _BuildNumberScorecardTestbed({
    Key key,
    this.buildNumberViewModel = const BuildNumberScorecardViewModel(),
    this.metricsThemeData = const MetricsThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: metricsThemeData,
      body: BuildNumberScorecard(
        buildNumberMetric: buildNumberViewModel,
      ),
    );
  }
}
