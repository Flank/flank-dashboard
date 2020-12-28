import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/navigation/metrics_page/metrics_page.dart';
import 'package:metrics/common/presentation/navigation/metrics_page/metrics_page_route.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matcher_util.dart';

// ignore_for_file: prefer_const_constructors

void main() {
  group("MetricsPage", () {
    const child = Text('child');

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

    test(
      ".createRoute() returns a metrics page with the given route name",
      () {
        const expectedName = 'test';
        const metricsPage = MetricsPage(child: child, name: expectedName);
        final actualRoute = metricsPage.createRoute(null);

        expect(actualRoute.settings.name, equals(expectedName));
      },
    );

    test(
      ".createRoute() applies the given arguments to the route settings' arguments",
      () {
        const arguments = 'test arguments';
        const metricsPage = MetricsPage(child: child, arguments: arguments);
        final actualRoute = metricsPage.createRoute(null);

        expect(
          actualRoute,
          isA<MetricsPageRoute>().having(
            (metricsPageRoute) => metricsPageRoute.settings.arguments,
            'route settings arguments',
            arguments,
          ),
        );
      },
    );

    test(
      ".createRoute() returns the metrics page route that builds the given child widget",
      () {
        const metricsPage = MetricsPage(child: child);
        final actualRoute = metricsPage.createRoute(null);

        expect(
          actualRoute,
          isA<MetricsPageRoute>().having(
            (metricsPageRoute) => metricsPageRoute.builder(null),
            'builds child widget',
            child,
          ),
        );
      },
    );
  });
}
