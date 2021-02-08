// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/shimmer_container.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_table/theme_data/project_metrics_table_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/shimmer_placeholder/theme_data/shimmer_placeholder_theme_data.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table_header_loading_placeholder.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("MetricsTableHeaderLoadingPlaceholder", () {
    const backgroundColor = Colors.black;
    const shimmerColor = Colors.red;

    const themeData = MetricsThemeData(
      projectMetricsTableTheme: ProjectMetricsTableThemeData(
        metricsTableHeaderPlaceholderTheme: ShimmerPlaceholderThemeData(
          backgroundColor: backgroundColor,
          shimmerColor: shimmerColor,
        ),
      ),
    );

    testWidgets(
      "applies the shimmer color from the metrics theme",
      (tester) async {
        await tester.pumpWidget(
          const _MetricsTableHeaderLoadingPlaceholderTestbed(
            themeData: themeData,
          ),
        );

        final shimmerContainer = tester.widget<ShimmerContainer>(
          find.byType(ShimmerContainer),
        );

        expect(shimmerContainer.shimmerColor, equals(shimmerColor));
      },
    );

    testWidgets(
      "applies the background color from the metrics theme",
      (tester) async {
        await tester.pumpWidget(
          const _MetricsTableHeaderLoadingPlaceholderTestbed(
            themeData: themeData,
          ),
        );

        final shimmerContainer = tester.widget<ShimmerContainer>(
          find.byType(ShimmerContainer),
        );

        expect(shimmerContainer.color, equals(backgroundColor));
      },
    );
  });
}

/// A testbed class required to test the [MetricsTableHeaderLoadingPlaceholder]
/// widget.
class _MetricsTableHeaderLoadingPlaceholderTestbed extends StatelessWidget {
  /// A [MetricsThemeData] used in tests.
  final MetricsThemeData themeData;

  /// Creates an instance of the metrics table header loading placeholder.
  ///
  /// The [themeData] defaults to a [MetricsThemeData].
  const _MetricsTableHeaderLoadingPlaceholderTestbed({
    Key key,
    this.themeData = const MetricsThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: themeData,
      body: const MetricsTableHeaderLoadingPlaceholder(),
    );
  }
}
