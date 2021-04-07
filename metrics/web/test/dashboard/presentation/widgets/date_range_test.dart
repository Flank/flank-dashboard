// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/model/date_range/theme_data/date_range_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_text/style/metrics_text_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/dashboard/presentation/view_models/date_range_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/date_range.dart';
import 'package:intl/intl.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("DateRange", () {
    final start = DateTime(2020);
    final end = DateTime(2021);

    final dateFormat = DateFormat('d MMM');

    testWidgets(
      "throws an AssertionError if the given date range view model is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _DateRangeTestbed(
            dateRange: null,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the formatted date range",
      (WidgetTester tester) async {
        final startFormatted = dateFormat.format(start);
        final endFormatted = dateFormat.format(end);
        final expectedText = '$startFormatted - $endFormatted';

        await tester.pumpWidget(
          _DateRangeTestbed(
            dateRange: DateRangeViewModel(
              start: start,
              end: end,
            ),
          ),
        );

        expect(find.text(expectedText), findsOneWidget);
      },
    );

    testWidgets(
      "displays only the start date if the start date equals to the end date",
      (WidgetTester tester) async {
        final expectedText = dateFormat.format(start);

        await tester.pumpWidget(
          _DateRangeTestbed(
            dateRange: DateRangeViewModel(
              start: start,
              end: start,
            ),
          ),
        );

        expect(find.text(expectedText), findsOneWidget);
      },
    );

    testWidgets(
      "applies the date range text style from the metrics theme",
      (WidgetTester tester) async {
        const textStyle = MetricsTextStyle(color: Colors.yellow);
        const metricsThemeData = MetricsThemeData(
          dateRangeTheme: DateRangeThemeData(
            textStyle: textStyle,
          ),
        );

        await tester.pumpWidget(
          _DateRangeTestbed(
            metricsThemeData: metricsThemeData,
            dateRange: DateRangeViewModel(
              start: start,
              end: end,
            ),
          ),
        );

        final text = tester.widget<Text>(find.byType(Text));

        expect(text.style, equals(textStyle));
      },
    );
  });
}

/// A testbed class required to test the [DateRange].
class _DateRangeTestbed extends StatelessWidget {
  /// A [MetricsThemeData] used in tests.
  final MetricsThemeData metricsThemeData;

  /// A [DateRangeViewModel] used in tests.
  final DateRangeViewModel dateRange;

  /// Creates a new instance of this testbed with the given [dateRange]
  /// and [metricsThemeData].
  ///
  /// A [metricsThemeData] defaults to an empty [MetricsThemeData].
  const _DateRangeTestbed({
    Key key,
    this.dateRange,
    this.metricsThemeData = const MetricsThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: metricsThemeData,
      body: DateRange(
        dateRange: dateRange,
      ),
    );
  }
}
