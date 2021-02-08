// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/circle_graph_indicator.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/attention_level/graph_indicator_attention_level.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/style/graph_indicator_style.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/theme_data/graph_indicator_theme_data.dart';
import 'package:metrics/common/presentation/graph_indicator/widgets/graph_indicator.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';

import '../../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("GraphIndicator", () {
    const metricsThemeData = MetricsThemeData(
      graphIndicatorTheme: GraphIndicatorThemeData(
        attentionLevel: GraphIndicatorAttentionLevel(
          positive: GraphIndicatorStyle(
            outerColor: Colors.white,
            innerColor: Colors.red,
          ),
        ),
      ),
    );

    final circleIndicatorFinder = find.byType(CircleGraphIndicator);

    CircleGraphIndicator _findCircleIndicator(WidgetTester tester) {
      return tester.widget<CircleGraphIndicator>(circleIndicatorFinder);
    }

    testWidgets("displays the circle graph indicator", (tester) async {
      await tester.pumpWidget(const _GraphIndicatorTestbed());

      expect(circleIndicatorFinder, findsOneWidget);
    });

    testWidgets(
      "applies an inner color to the graph indicator from the metrics theme",
      (tester) async {
        final theme = metricsThemeData.graphIndicatorTheme;
        final expectedInnerColor = theme.attentionLevel.positive.innerColor;

        await tester.pumpWidget(
          const _GraphIndicatorTestbed(metricsThemeData: metricsThemeData),
        );

        final circleIndicator = _findCircleIndicator(tester);
        final innerColor = circleIndicator.innerColor;

        expect(innerColor, equals(expectedInnerColor));
      },
    );

    testWidgets(
      "applies an outer color to the graph indicator from the metrics theme",
      (tester) async {
        final theme = metricsThemeData.graphIndicatorTheme;
        final expectedOuterColor = theme.attentionLevel.positive.outerColor;

        await tester.pumpWidget(
          const _GraphIndicatorTestbed(metricsThemeData: metricsThemeData),
        );

        final circleIndicator = _findCircleIndicator(tester);
        final outerColor = circleIndicator.outerColor;

        expect(outerColor, equals(expectedOuterColor));
      },
    );

    testWidgets(
      "applies the outer diameter from the dimensions config to the circle indicator",
      (tester) async {
        const expectedDiameter = DimensionsConfig.graphIndicatorOuterDiameter;
        await tester.pumpWidget(const _GraphIndicatorTestbed());

        final circleIndicator = _findCircleIndicator(tester);
        final diameter = circleIndicator.outerDiameter;

        expect(diameter, equals(expectedDiameter));
      },
    );

    testWidgets(
      "applies the inner diameter from the dimensions config to the circle indicator",
      (tester) async {
        const expectedDiameter = DimensionsConfig.graphIndicatorInnerDiameter;
        await tester.pumpWidget(const _GraphIndicatorTestbed());

        final circleIndicator = _findCircleIndicator(tester);
        final diameter = circleIndicator.innerDiameter;

        expect(diameter, equals(expectedDiameter));
      },
    );
  });
}

/// A testbed widget, used to test the [GraphIndicator] widget.
class _GraphIndicatorTestbed extends StatelessWidget {
  /// A [MetricsThemeData] used in tests.
  final MetricsThemeData metricsThemeData;

  /// Creates an instance of the [_GraphIndicatorTestbed].
  ///
  /// The [metricsThemeData] defaults to an empty [MetricsThemeData] instance.
  const _GraphIndicatorTestbed({
    Key key,
    this.metricsThemeData = const MetricsThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: metricsThemeData,
      body: const _GraphIndicatorFake(),
    );
  }
}

/// A fake implementation of the [GraphIndicator] widget used for testing.
/// Applies the [GraphIndicatorAttentionLevel.positive] graph indicator style.
class _GraphIndicatorFake extends GraphIndicator {
  /// Creates an instance of the [_GraphIndicatorFake].
  const _GraphIndicatorFake({Key key}) : super(key: key);

  @override
  GraphIndicatorStyle selectStyle(GraphIndicatorAttentionLevel attentionLevel) {
    return attentionLevel.positive;
  }
}
