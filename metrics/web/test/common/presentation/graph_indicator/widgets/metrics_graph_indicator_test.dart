// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/circle_graph_indicator.dart';
import 'package:metrics/common/presentation/graph_indicator/strategy/metrics_graph_indicator_appearance_strategy.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/attention_level/graph_indicator_attention_level.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/style/graph_indicator_style.dart';
import 'package:metrics/common/presentation/graph_indicator/widgets/metrics_graph_indicator.dart';
import 'package:mockito/mockito.dart';

import '../../../../test_utils/matchers.dart';
import '../../../../test_utils/metrics_themed_testbed.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("MetricsGraphIndicator", () {
    const value = 1;
    const innerColor = Colors.black;
    const outerColor = Colors.yellow;
    const style = GraphIndicatorStyle(
      innerColor: innerColor,
      outerColor: outerColor,
    );

    final circleGraphIndicatorFinder = find.byType(CircleGraphIndicator);

    final strategy = _MetricsGraphIndicatorAppearanceStrategyMock<int>();

    tearDown(() {
      reset(strategy);
    });

    testWidgets(
      "throws an AssertionError if the given strategy is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _MetricsGraphIndicatorTestbed(
            value: value,
            strategy: null,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "selects the graph indicator style using the given value and strategy",
      (WidgetTester tester) async {
        when(strategy.selectStyle(any, value)).thenReturn(style);

        await tester.pumpWidget(
          _MetricsGraphIndicatorTestbed(
            value: value,
            strategy: strategy,
          ),
        );

        verify(strategy.selectStyle(any, value)).called(once);
      },
    );

    testWidgets(
      ".selectStyle() returns the graph indicator style returned by the metrics graph indicator appearance strategy",
      (WidgetTester tester) async {
        when(strategy.selectStyle(any, value)).thenReturn(style);

        await tester.pumpWidget(
          _MetricsGraphIndicatorTestbed(
            value: value,
            strategy: strategy,
          ),
        );

        final graphIndicator = tester.widget<MetricsGraphIndicator>(
          find.byType(MetricsGraphIndicator),
        );
        final graphIndicatorStyle = graphIndicator.selectStyle(
          const GraphIndicatorAttentionLevel(),
        );

        expect(graphIndicatorStyle, equals(style));
      },
    );

    testWidgets(
      "applies the inner color of the graph indicator style returned by the strategy",
      (WidgetTester tester) async {
        final expectedInnerColor = style.innerColor;
        when(strategy.selectStyle(any, value)).thenReturn(style);

        await tester.pumpWidget(
          _MetricsGraphIndicatorTestbed(
            value: value,
            strategy: strategy,
          ),
        );

        final indicator = tester.widget<CircleGraphIndicator>(
          circleGraphIndicatorFinder,
        );

        expect(indicator.innerColor, equals(expectedInnerColor));
      },
    );

    testWidgets(
      "applies the outer color of the graph indicator style returned by the strategy",
      (WidgetTester tester) async {
        final expectedOuterColor = style.outerColor;
        when(strategy.selectStyle(any, value)).thenReturn(style);

        await tester.pumpWidget(
          _MetricsGraphIndicatorTestbed(
            value: value,
            strategy: strategy,
          ),
        );

        final indicator = tester.widget<CircleGraphIndicator>(
          circleGraphIndicatorFinder,
        );

        expect(indicator.outerColor, equals(expectedOuterColor));
      },
    );
  });
}

/// A testbed class required to test the [MetricsGraphIndicator].
class _MetricsGraphIndicatorTestbed<T> extends StatelessWidget {
  /// A [MetricsGraphIndicatorAppearanceStrategy] to use in tests.
  final MetricsGraphIndicatorAppearanceStrategy<T> strategy;

  /// A value of this testbed to use in tests.
  final T value;

  /// Creates the [_MetricsGraphIndicatorTestbed] with the given [strategy] and
  /// [value].
  const _MetricsGraphIndicatorTestbed({
    Key key,
    this.strategy,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      body: MetricsGraphIndicator(
        strategy: strategy,
        value: value,
      ),
    );
  }
}

class _MetricsGraphIndicatorAppearanceStrategyMock<T> extends Mock
    implements MetricsGraphIndicatorAppearanceStrategy {}
