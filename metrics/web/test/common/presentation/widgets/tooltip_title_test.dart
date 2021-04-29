// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_table/theme_data/metrics_table_header_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_table/theme_data/project_metrics_table_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/tooltip_icon/widgets/tooltip_icon.dart';
import 'package:metrics/common/presentation/widgets/tooltip_title.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("TooltipIcon", () {
    const title = 'test';
    const themeData = MetricsThemeData(
      projectMetricsTableTheme: ProjectMetricsTableThemeData(
        metricsTableHeaderTheme: MetricsTableHeaderThemeData(
          textStyle: TextStyle(color: Colors.red),
        ),
      ),
    );

    final titleFinder = find.text(title);
    final tooltipIconFinder = find.byType(TooltipIcon);

    testWidgets(
      "throws an AssertionError if the given title is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _TooltipTitleTestbed(title: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given tooltip is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _TooltipTitleTestbed(tooltip: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given src is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _TooltipTitleTestbed(src: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets("displays the given title text", (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(const _TooltipTitleTestbed(title: title));
      });

      expect(titleFinder, findsOneWidget);
    });

    testWidgets(
      "applies the text style from the metrics theme to the title text",
      (WidgetTester tester) async {
        final theme =
            themeData.projectMetricsTableTheme.metricsTableHeaderTheme;
        final textStyle = theme.textStyle;

        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(const _TooltipTitleTestbed(
            themeData: themeData,
            title: title,
          ));
        });

        final text = tester.widget<Text>(titleFinder);

        expect(text.style, textStyle);
      },
    );

    testWidgets("displays the TooltipIcon", (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(const _TooltipTitleTestbed());
      });

      expect(tooltipIconFinder, findsOneWidget);
    });

    testWidgets(
      "displays the TooltipIcon with the given tooltip",
      (WidgetTester tester) async {
        const tooltip = 'test';

        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(const _TooltipTitleTestbed(tooltip: tooltip));
        });

        final tooltipIcon = tester.widget<TooltipIcon>(tooltipIconFinder);

        expect(tooltipIcon.tooltip, tooltip);
      },
    );

    testWidgets(
      "displays the TooltipIcon with the given icon src",
      (WidgetTester tester) async {
        const src = 'test';

        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(const _TooltipTitleTestbed(src: src));
        });

        final tooltipIcon = tester.widget<TooltipIcon>(tooltipIconFinder);

        expect(tooltipIcon.src, src);
      },
    );
  });
}

/// A testbed class required to test the [_TooltipTitleTestbed].
class _TooltipTitleTestbed extends StatelessWidget {
  /// A title of the [TooltipTitle].
  final String title;

  /// A tooltip text of the [TooltipTitle].
  final String tooltip;

  /// A [TooltipTitle]'s source of the icon.
  final String src;

  /// A [MetricsThemeData] used in tests.
  final MetricsThemeData themeData;

  /// Creates a new instance of the [_TooltipTitleTestbed].
  ///
  /// The [themeData] defaults to an empty [MetricsThemeData] instance.
  /// The [title] defaults to `title`.
  /// The [tooltip] defaults to `tooltip`.
  /// The [src] defaults to `src`.
  const _TooltipTitleTestbed({
    Key key,
    this.themeData = const MetricsThemeData(),
    this.title = 'title',
    this.tooltip = 'tooltip',
    this.src = 'src',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: themeData,
      body: TooltipTitle(
        src: src,
        title: title,
        tooltip: tooltip,
      ),
    );
  }
}
