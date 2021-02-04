// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/shimmer_container.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/shimmer_placeholder/theme_data/shimmer_placeholder_theme_data.dart';
import 'package:metrics/common/presentation/widgets/metrics_input_placeholder.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("MetricsInputPlaceholder", () {
    const backgroundColor = Colors.black;
    const shimmerColor = Colors.grey;

    const theme = MetricsThemeData(
      inputPlaceholderTheme: ShimmerPlaceholderThemeData(
        backgroundColor: backgroundColor,
        shimmerColor: shimmerColor,
      ),
    );

    testWidgets(
      "applies a background color from the metrics theme to a color of the shimmer container",
      (tester) async {
        await tester.pumpWidget(const _MetricsInputPlaceholderTestbed(
          theme: theme,
        ));

        final shimmerContainer = tester.widget<ShimmerContainer>(
          find.byType(ShimmerContainer),
        );

        expect(shimmerContainer.color, equals(backgroundColor));
      },
    );

    testWidgets(
      "applies a shimmer color from the metrics theme to a color of the shimmer container",
      (tester) async {
        await tester.pumpWidget(const _MetricsInputPlaceholderTestbed(
          theme: theme,
        ));

        final shimmerContainer = tester.widget<ShimmerContainer>(
          find.byType(ShimmerContainer),
        );

        expect(shimmerContainer.shimmerColor, equals(shimmerColor));
      },
    );
  });
}

/// A testbed widget, used to test the [MetricsInputPlaceholder] widget.
class _MetricsInputPlaceholderTestbed extends StatelessWidget {
  /// The [MetricsThemeData] used in tests.
  final MetricsThemeData theme;

  /// Creates the metrics input placeholder testbed.
  ///
  /// The [theme] defaults to an empty [MetricsThemeData] instance.
  const _MetricsInputPlaceholderTestbed({
    Key key,
    this.theme = const MetricsThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: theme,
      body: const MetricsInputPlaceholder(),
    );
  }
}
