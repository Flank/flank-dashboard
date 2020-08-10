import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/graphs/circle_percentage.dart';
import 'package:metrics/common/presentation/metrics_theme/model/circle_percentage/style/circle_percentage_style.dart';
import 'package:metrics/dashboard/presentation/view_models/percent_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/no_data_placeholder.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/metrics_value_theme_strategy.dart';
import 'package:metrics/dashboard/presentation/widgets/themed_circle_percentage.dart';
import 'package:mockito/mockito.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("ThemedCirclePercentage", () {
    const style = CirclePercentageStyle(
      valueColor: Colors.red,
      strokeColor: Colors.blue,
      backgroundColor: Colors.white,
      valueStyle: TextStyle(
        color: Colors.orange,
      ),
    );

    final themeStrategy = CirclePercentageThemeStrategyMock();

    setUp(() {
      reset(themeStrategy);
      when(themeStrategy.getWidgetAppearance(any, any)).thenReturn(style);
    });

    testWidgets(
      "can't be with null percent value",
      (tester) async {
        await tester.pumpWidget(
          const _ThemedCirclePercentageTestbed(percent: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "applies the value color from the metrics theme given by theme strategy",
      (tester) async {
        await tester.pumpWidget(_ThemedCirclePercentageTestbed(
          strategy: themeStrategy,
        ));

        final circlePercentageWidget =
            tester.widget<CirclePercentage>(find.byType(CirclePercentage));

        expect(
          circlePercentageWidget.valueColor,
          style.valueColor,
        );
      },
    );

    testWidgets(
      "applies the stroke color from the metrics theme given by theme strategy",
      (tester) async {
        await tester.pumpWidget(_ThemedCirclePercentageTestbed(
          strategy: themeStrategy,
        ));

        final circlePercentageWidget =
            tester.widget<CirclePercentage>(find.byType(CirclePercentage));

        expect(
          circlePercentageWidget.strokeColor,
          style.strokeColor,
        );
      },
    );

    testWidgets(
      "applies the background color from the metrics theme given by theme strategy",
      (tester) async {
        await tester.pumpWidget(_ThemedCirclePercentageTestbed(
          strategy: themeStrategy,
        ));

        final circlePercentageWidget =
            tester.widget<CirclePercentage>(find.byType(CirclePercentage));

        expect(
          circlePercentageWidget.backgroundColor,
          style.backgroundColor,
        );
      },
    );

    testWidgets(
      "applies the value style from the metrics theme given by theme strategy",
      (tester) async {
        await tester.pumpWidget(_ThemedCirclePercentageTestbed(
          strategy: themeStrategy,
        ));

        final circlePercentageWidget =
            tester.widget<CirclePercentage>(find.byType(CirclePercentage));

        expect(
          circlePercentageWidget.valueStyle,
          style.valueStyle,
        );
      },
    );

    testWidgets(
      "can't be created with null themeStrategy",
      (tester) async {
        await tester.pumpWidget(const _ThemedCirclePercentageTestbed(
          strategy: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the no data placeholder if percent value is null",
      (tester) async {
        const percent = PercentViewModel(null);

        await tester.pumpWidget(const _ThemedCirclePercentageTestbed(
          percent: percent,
        ));

        expect(find.byType(NoDataPlaceholder), findsOneWidget);
      },
    );
  });
}

/// A testbed class required for testing the [ThemedCirclePercentage].
class _ThemedCirclePercentageTestbed extends StatelessWidget {
  /// A [MetricsValueThemeStrategy] used to chose the theme to use in widget.
  final MetricsValueThemeStrategy strategy;

  /// A [PercentViewModel] instance to display.
  final PercentViewModel percent;

  /// Creates this testbed instance with the given [percent] value and theme [strategy].
  ///
  /// The [percent] defaults to the [PercentViewModel] instance with value equals to `1.0`.
  /// The [strategy] defaults to the [MetricsValueThemeStrategy].
  const _ThemedCirclePercentageTestbed({
    Key key,
    this.percent = const PercentViewModel(1.0),
    this.strategy = const MetricsValueThemeStrategy(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      body: ThemedCirclePercentage(
        percent: percent,
        themeStrategy: strategy,
      ),
    );
  }
}

class CirclePercentageThemeStrategyMock extends Mock
    implements MetricsValueThemeStrategy {}
