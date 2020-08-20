import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/shimmer_container.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_table/theme_data/project_metrics_table_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/shimmer_placeholder/theme_data/shimmer_placeholder_theme_data.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table_loading_placeholder.dart';

import '../../../test_utils/dimensions_util.dart';
import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("MetricsTableLoadingPlaceholder", () {
    const backgroundColor = Colors.black;
    const shimmerColor = Colors.red;

    const themeData = MetricsThemeData(
      projectMetricsTableTheme: ProjectMetricsTableThemeData(
        projectMetricsTilePlaceholderTheme: ShimmerPlaceholderThemeData(
          backgroundColor: backgroundColor,
          shimmerColor: shimmerColor,
        ),
      ),
    );

    testWidgets(
      "applies the shimmer color from the metrics theme to the shimmer container",
      (tester) async {
        await tester.pumpWidget(
          const _MetricsTableLoadingPlaceholderTestbed(themeData: themeData),
        );

        final shimmerContainer = tester.widget<ShimmerContainer>(
          find.byType(ShimmerContainer).first,
        );

        expect(shimmerContainer.shimmerColor, equals(shimmerColor));
      },
    );

    testWidgets(
      "applies the loading background color from the metrics theme to the shimmer container",
      (tester) async {
        await tester.pumpWidget(
          const _MetricsTableLoadingPlaceholderTestbed(themeData: themeData),
        );

        final shimmerContainer = tester.widget<ShimmerContainer>(
          find.byType(ShimmerContainer).first,
        );

        expect(shimmerContainer.color, equals(backgroundColor));
      },
    );

    testWidgets(
      "displays a number of shimmer containers that can fit on the screen",
      (tester) async {
        const height = 300.0;
        const itemHeight = 144.0;

        final expectedItemCount = (height / itemHeight).ceil();

        DimensionsUtil.setTestWindowSize(height: height);
        addTearDown(DimensionsUtil.clearTestWindowSize);

        await tester.pumpWidget(
          const _MetricsTableLoadingPlaceholderTestbed(),
        );

        final actualItemCount = tester
            .widgetList<ShimmerContainer>(find.byType(ShimmerContainer))
            .length;

        expect(actualItemCount, equals(expectedItemCount));
      },
    );
  });
}

/// A testbed class required to test the [MetricsTableLoadingPlaceholder] widget.
class _MetricsTableLoadingPlaceholderTestbed extends StatelessWidget {
  /// A [MetricsThemeData] used in tests.
  final MetricsThemeData themeData;

  /// Creates an instance of the [_MetricsTableLoadingPlaceholderTestbed].
  ///
  /// The [themeData] defaults to a [MetricsThemeData].
  const _MetricsTableLoadingPlaceholderTestbed({
    Key key,
    this.themeData = const MetricsThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: themeData,
      body: MetricsTableLoadingPlaceholder(),
    );
  }
}
