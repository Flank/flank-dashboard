import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/page_title/theme/page_title_theme_data.dart';
import 'package:metrics/common/presentation/page_title/widgets/metrics_page_title.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("MetricsPageTitle", () {
    const testIconColor = Colors.red;
    const testTextStyle = TextStyle(fontSize: 6.0);
    const testTheme = MetricsThemeData(
      pageTitleTheme: PageTitleThemeData(
        iconColor: testIconColor,
        textStyle: testTextStyle,
      ),
    );

    testWidgets(
      "throws an AssertionError if a text is null",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            const _MetricsPageTitleTestbed(title: null),
          );
        });

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets("displays the arrow back icon", (WidgetTester tester) async {
      await mockNetworkImagesFor(() {
        return tester.pumpWidget(
          const _MetricsPageTitleTestbed(),
        );
      });

      final finder = find.descendant(
        of: find.byTooltip(CommonStrings.navigateBack),
        matching: find.byType(Image),
      );

      expect(finder, findsOneWidget);
    });

    testWidgets(
      "applies a tappable area to the arrow back icon",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            const _MetricsPageTitleTestbed(),
          );
        });

        final finder = find.descendant(
          of: find.byTooltip(CommonStrings.navigateBack),
          matching: find.byType(TappableArea),
        );

        expect(finder, findsOneWidget);
      },
    );

    testWidgets("displays the given title", (WidgetTester tester) async {
      const title = 'test';

      await mockNetworkImagesFor(() {
        return tester.pumpWidget(
          const _MetricsPageTitleTestbed(title: title),
        );
      });

      expect(find.text(title), findsOneWidget);
    });

    testWidgets(
      "navigates back to the previous screen",
      (WidgetTester tester) async {
        await tester.pumpWidget(_NavigationTestbed());

        await tester.tap(find.byType(_NavigationTestbed));
        await mockNetworkImagesFor(() {
          return tester.pumpAndSettle();
        });

        expect(find.byType(MetricsPageTitle), findsOneWidget);

        await tester.tap(find.byTooltip(CommonStrings.navigateBack));
        await tester.pumpAndSettle();

        expect(find.byType(MetricsPageTitle), findsNothing);
      },
    );

    testWidgets(
      "doesn't navigate back if there is no previous page",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsPageTitleTestbed());
        });

        await tester.tap(find.byTooltip(CommonStrings.navigateBack));
        await tester.pumpAndSettle();

        expect(find.byType(MetricsPageTitle), findsOneWidget);
      },
    );

    testWidgets(
      "applies the title style from the metrics theme to the title text",
      (WidgetTester tester) async {
        const testTitle = 'test title';

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsPageTitleTestbed(
            theme: testTheme,
            title: testTitle,
          ));
        });

        final textWidget = tester.widget<Text>(
          find.text(testTitle),
        );

        expect(textWidget.style, equals(testTextStyle));
      },
    );

    testWidgets(
      "applies the icon color from the metrics theme to the icon",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsPageTitleTestbed(
            theme: testTheme,
          ));
        });

        final iconFinder = find.descendant(
          of: find.byTooltip(CommonStrings.navigateBack),
          matching: find.byType(Image),
        );

        final iconWidget = tester.widget<Image>(iconFinder);

        expect(iconWidget.color, equals(testIconColor));
      },
    );
  });
}

/// A testbed widget, used to test the navigation
/// to the [MetricsPageTitle] widget.
class _NavigationTestbed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Scaffold(
                  body: MetricsPageTitle(
                    title: "title",
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A testbed widget, used to test the [MetricsPageTitle] widget.
class _MetricsPageTitleTestbed extends StatelessWidget {
  /// A title to display.
  final String title;

  /// A [MetricsThemeData] used in this testbed.
  final MetricsThemeData theme;

  /// Creates the [_MetricsPageTitleTestbed] with the given [title]
  ///
  /// The [title] defaults to `title`.
  /// The [theme] defaults to [MetricsThemeData].
  const _MetricsPageTitleTestbed({
    Key key,
    this.title = 'title',
    this.theme = const MetricsThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: theme,
      body: MetricsPageTitle(
        title: title,
      ),
    );
  }
}
