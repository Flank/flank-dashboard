import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/routes/metrics_page_route.dart';
import 'package:metrics/common/presentation/routes/route_name.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';

void main() {
  group("MetricsPageRoute", () {
    test(
      "throws an AssertionError if the builder is null",
      () {
        expect(
          () => MetricsPageRoute(
            builder: null,
            settings: const RouteSettings(name: RouteName.login),
          ),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      "throws an AssertionError if the maintainState is null",
      () {
        expect(
          () => MetricsPageRoute(
            builder: (_) => Container(),
            settings: const RouteSettings(name: RouteName.login),
            maintainState: null,
          ),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      "throws an AssertionError if the fullscreenDialog is null",
      () {
        expect(
          () => MetricsPageRoute(
            builder: (_) => Container(),
            settings: const RouteSettings(name: RouteName.login),
            fullscreenDialog: null,
          ),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      ".buildTransitions() returns given child widget",
      () {
        const expectedChild = Text("Child");
        final route = MetricsPageRoute(
          builder: (_) => expectedChild,
        );
        final child = route.buildTransitions(null, null, null, expectedChild);
        expect(child, equals(expectedChild));
      },
    );
  });
}
