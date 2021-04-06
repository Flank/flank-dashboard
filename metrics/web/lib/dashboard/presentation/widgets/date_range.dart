// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/dashboard/presentation/view_models/date_range_view_model.dart';
import 'package:metrics/util/date.dart';

/// A widget that display the given [dateRange].
///
/// Applies the [TextStyle] from the [MetricsTheme].
class DateRange extends StatelessWidget {
  /// A [DateRangeViewModel] with the data to display.
  final DateRangeViewModel dateRange;

  /// Create a new instance of the [DateRange] with the given [dateRange].
  ///
  /// Throws an [AssertionError] if the given [dateRange] is `null`.
  const DateRange({
    Key key,
    @required this.dateRange,
  })  : assert(dateRange != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final buildResultBarGraphTheme =
        MetricsTheme.of(context).buildResultBarGraphTheme;

    return Text(
      _formatDatePeriod(),
      style: buildResultBarGraphTheme.textStyle,
    );
  }

  /// Returns a [String] containing the formatted [dateRange].
  ///
  /// Returns the formatted [DateRangeViewModel.start],
  /// if it equals to the [DateRangeViewModel.end].
  String _formatDatePeriod() {
    final dateFormat = DateFormat('d MMM');

    final firstDate = dateRange.start;
    final lastDate = dateRange.end;

    final firstDateFormatted = dateFormat.format(firstDate);

    if (firstDate.date == lastDate.date) {
      return firstDateFormatted;
    }

    final lastDateFormatted = dateFormat.format(lastDate);

    return '$firstDateFormatted - $lastDateFormatted';
  }
}
