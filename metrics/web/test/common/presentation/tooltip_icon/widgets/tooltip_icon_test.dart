// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/svg_image.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/tooltip_icon/theme/theme_data/tooltip_icon_theme_data.dart';
import 'package:metrics/common/presentation/tooltip_icon/widgets/tooltip_icon.dart';
import 'package:metrics/common/presentation/tooltip_popup/widgets/tooltip_popup.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../../test_utils/finder_util.dart';
import '../../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("TooltipIcon", () {
    const themeData = MetricsThemeData(
      tooltipIconTheme: TooltipIconThemeData(
        color: Colors.red,
        hoverColor: Colors.yellow,
      ),
    );

    final mouseRegionFinder = find.ancestor(
      of: find.byType(SvgImage),
      matching: find.byType(MouseRegion),
    );

    Future<void> _hoverBar(WidgetTester tester) async {
      final mouseRegion = tester.widget<MouseRegion>(mouseRegionFinder);
      mouseRegion.onEnter(const PointerEnterEvent());

      return tester.pumpAndSettle();
    }

    testWidgets(
      "throws an AssertionError if the given tooltip is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _TooltipIconTestbed(tooltip: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given src is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _TooltipIconTestbed(src: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the icon from the given src",
      (WidgetTester tester) async {
        const src = 'test';

        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(const _TooltipIconTestbed(src: src));
        });

        final icon = FinderUtil.findSvgImage(tester);

        expect(icon.src, equals(src));
      },
    );

    testWidgets(
      "opens the TooltipPopup widget on hover with the given tooltip text",
      (WidgetTester tester) async {
        const tooltip = 'test';

        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(const _TooltipIconTestbed(tooltip: tooltip));
        });

        await _hoverBar(tester);

        final popup = tester.widget<TooltipPopup>(find.byType(TooltipPopup));

        expect(popup.tooltip, tooltip);
      },
    );

    testWidgets(
      "applies the color from the metrics theme to the icon if popup is closed",
      (WidgetTester tester) async {
        final color = themeData.tooltipIconTheme.color;

        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(const _TooltipIconTestbed(
            themeData: themeData,
          ));
        });

        final icon = FinderUtil.findSvgImage(tester);

        expect(icon.color, color);
      },
    );

    testWidgets(
      "applies the hover color from the metrics theme to the icon if popup is opened",
      (WidgetTester tester) async {
        final hoverColor = themeData.tooltipIconTheme.hoverColor;

        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(const _TooltipIconTestbed(
            themeData: themeData,
          ));
        });

        await _hoverBar(tester);

        final icon = FinderUtil.findSvgImage(tester);

        expect(icon.color, hoverColor);
      },
    );
  });
}

/// A testbed class required to test the [TooltipIcon].
class _TooltipIconTestbed extends StatelessWidget {
  /// A tooltip text to display in the [TooltipPopup].
  final String tooltip;

  /// A [TooltipIcon]'s source of the icon.
  final String src;

  /// A [MetricsThemeData] used in tests.
  final MetricsThemeData themeData;

  /// Creates a new instance of the [_TooltipIconTestbed].
  ///
  /// The [themeData] defaults to an empty [MetricsThemeData] instance.
  /// The [tooltip] defaults to `tooltip`.
  /// The [src] defaults to `src`.
  const _TooltipIconTestbed({
    Key key,
    this.themeData = const MetricsThemeData(),
    this.tooltip = 'tooltip',
    this.src = 'src',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: themeData,
      body: TooltipIcon(
        src: src,
        tooltip: tooltip,
      ),
    );
  }
}
