import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/navigation/metrics_page/metrics_page.dart';
import 'package:metrics/common/presentation/navigation/metrics_page/metrics_page_route.dart';

import '../../../../test_utils/matcher_util.dart';

// ignore_for_file: prefer_const_constructors

void main() {
  group("MetricsPage", () {
    const child = Text('child');
    const metricsPage = MetricsPage(child: child);

    test("throws an AssertionError if the child is null", () {
      expect(
        () => MetricsPage(child: null),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("throws an AssertionError if the maintain state is null", () {
      expect(
        () => MetricsPage(
          child: child,
          maintainState: null,
        ),
        MatcherUtil.throwsAssertionError,
      );
    });
    test("throws an AssertionError if the fullscreen dialog is null", () {
      expect(
        () => MetricsPage(
          child: child,
          fullscreenDialog: null,
        ),
        MatcherUtil.throwsAssertionError,
      );
    });

    test(
      "uses the default maintain state value if the given parameter is not specified",
      () {
        final metricsPage = MetricsPage(child: child);

        expect(metricsPage.maintainState, isNotNull);
      },
    );

    test(
      "uses the default fullscreen dialog value if the given parameter is not specified",
      () {
        final metricsPage = MetricsPage(child: child);

        expect(metricsPage.fullscreenDialog, isNotNull);
      },
    );

    testWidgets(
      "displays the given child",
      (WidgetTester tester) async {
        final key = GlobalKey();

        await tester.pumpWidget(
          _MetricsPageTestbed(
            pages: const [metricsPage],
            key: key,
          ),
        );

        expect(find.byWidget(child), findsOneWidget);
      },
    );
  });
}

class _MetricsPageTestbed extends StatelessWidget {
  final List<Page> pages;

  const _MetricsPageTestbed({
    Key key,
    this.pages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Navigator(
        pages: pages,
        onPopPage: (route, result) => true,
      ),
    );
  }
}
