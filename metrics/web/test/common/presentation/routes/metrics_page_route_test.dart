import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/navigation/constants/metrics_routes.dart';
import 'package:metrics/common/presentation/routes/metrics_page_route.dart';
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
            settings: RouteSettings(name: MetricsRoutes.login.path),
          ),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      "throws an AssertionError if the maintain state is null",
      () {
        expect(
          () => MetricsPageRoute(
            builder: (_) => Container(),
            settings: RouteSettings(name: MetricsRoutes.login.path),
            maintainState: null,
          ),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      "throws an AssertionError if the fullscreen dialog is null",
      () {
        expect(
          () => MetricsPageRoute(
            builder: (_) => Container(),
            settings: RouteSettings(name: MetricsRoutes.login.path),
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
