import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/circle_graph_indicator.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/attention_level/graph_indicator_attention_level.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/style/graph_indicator_style.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/theme_data/graph_indicator_theme_data.dart';
import 'package:metrics/common/presentation/graph_indicator/widgets/graph_indicator.dart';
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

    testWidgets(
      "applies an inner color to the graph indicator from the metrics theme",
      (tester) async {
        final theme = metricsThemeData.graphIndicatorTheme;
        final expectedInnerColor = theme.attentionLevel.positive.innerColor;

        await tester.pumpWidget(
          const _GraphIndicatorTestbed(metricsThemeData: metricsThemeData),
        );

        final circleIndicator = tester.widget<CircleGraphIndicator>(
          circleIndicatorFinder,
        );
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

        final circleIndicator = tester.widget<CircleGraphIndicator>(
          circleIndicatorFinder,
        );
        final outerColor = circleIndicator.outerColor;

        expect(outerColor, equals(expectedOuterColor));
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
      body: const _GraphIndicatorStub(),
    );
  }
}

/// A stub implementation of the [GraphIndicator] widget used for testing.
/// Applies the [GraphIndicatorAttentionLevel.positive] graph indicator style.
class _GraphIndicatorStub extends GraphIndicator {
  /// Creates an instance of the [_GraphIndicatorStub].
  const _GraphIndicatorStub({Key key}) : super(key: key);

  @override
  GraphIndicatorStyle selectStyle(GraphIndicatorAttentionLevel attentionLevel) {
    return attentionLevel.positive;
  }
}
