import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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

    testWidgets("displays the given title", (WidgetTester tester) async {
      const title = 'title';

      await mockNetworkImagesFor(() {
        return tester.pumpWidget(
          const _MetricsPageTitleTestbed(title: title),
        );
      });

      expect(find.text(title), findsOneWidget);
    });
  });
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
