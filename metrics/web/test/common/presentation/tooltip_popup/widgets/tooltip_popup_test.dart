// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/tooltip_popup/theme/theme_data/tooltip_popup_theme_data.dart';
import 'package:metrics/common/presentation/tooltip_popup/widgets/tooltip_popup.dart';

import '../../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("TooltipPopup", () {
    const themeData = MetricsThemeData(
      tooltipPopupTheme: TooltipPopupThemeData(
        backgroundColor: Colors.black,
        shadowColor: Colors.grey,
        textStyle: TextStyle(backgroundColor: Colors.red),
      ),
    );

    testWidgets(
      "throws an AssertionError if the given tooltip is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _TooltipPopupTestbed(tooltip: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "applies the shadow color from the metrics theme to the tooltip popup",
      (WidgetTester tester) async {
        final shadowColor = themeData.tooltipPopupTheme.shadowColor;

        await tester.pumpWidget(
          const _TooltipPopupTestbed(themeData: themeData),
        );

        final container = tester.widget<Container>(
          find.ancestor(
            of: find.byType(Card),
            matching: find.byType(Container),
          ),
        );
        final decoration = container.decoration as BoxDecoration;
        final boxShadow = decoration.boxShadow.first;

        expect(boxShadow.color, equals(shadowColor));
      },
    );

    testWidgets(
      "applies the background color from the metrics theme to the tooltip popup",
      (WidgetTester tester) async {
        final backgroundColor = themeData.tooltipPopupTheme.backgroundColor;

        await tester.pumpWidget(
          const _TooltipPopupTestbed(themeData: themeData),
        );

        final card = tester.widget<Card>(find.byType(Card));

        expect(card.color, equals(backgroundColor));
      },
    );

    testWidgets(
      "displays the given tooltip text",
      (WidgetTester tester) async {
        const tooltip = "test";

        await tester.pumpWidget(
          const _TooltipPopupTestbed(tooltip: tooltip),
        );

        expect(find.text(tooltip), findsOneWidget);
      },
    );

    testWidgets(
      "applies the text style from the metrics theme to the tooltip text",
      (WidgetTester tester) async {
        const tooltip = "test";
        final textStyle = themeData.tooltipPopupTheme.textStyle;

        await tester.pumpWidget(
          const _TooltipPopupTestbed(
            tooltip: tooltip,
            themeData: themeData,
          ),
        );

        final textWidget = tester.widget<Text>(find.text(tooltip));

        expect(textWidget.style, equals(textStyle));
      },
    );
  });
}

/// A testbed class required to test the [TooltipPopup].
class _TooltipPopupTestbed extends StatelessWidget {
  /// A tooltip text of the [TooltipPopup].
  final String tooltip;

  /// A [MetricsThemeData] used in tests.
  final MetricsThemeData themeData;

  /// Creates a new instance of the [_TooltipPopupTestbed].
  ///
  /// The [themeData] defaults to an empty [MetricsThemeData] instance.
  /// The [tooltip] defaults to `tooltip`.
  const _TooltipPopupTestbed({
    Key key,
    this.themeData = const MetricsThemeData(),
    this.tooltip = 'tooltip',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: themeData,
      body: TooltipPopup(
        tooltip: tooltip,
      ),
    );
  }
}
