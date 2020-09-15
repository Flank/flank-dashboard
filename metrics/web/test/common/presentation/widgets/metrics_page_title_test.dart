import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/widgets/metrics_page_title.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  group("MetricsPageTitle", () {
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
      "applies a mouse region to the arrow back icon",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            const _MetricsPageTitleTestbed(),
          );
        });

        final finder = find.descendant(
          of: find.byTooltip(CommonStrings.navigateBack),
          matching: find.byType(MouseRegion),
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

  /// Creates the [_MetricsPageTitleTestbed] with the given [title]
  ///
  /// The [title] defaults to `title`.
  const _MetricsPageTitleTestbed({
    Key key,
    this.title = 'title',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MetricsPageTitle(
          title: title,
        ),
      ),
    );
  }
}
