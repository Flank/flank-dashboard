import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/routes/metrics_page_route.dart';
import 'package:metrics/common/presentation/routes/route_generator.dart';
import 'package:metrics/common/presentation/routes/route_name.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';

void main() {
  group("RouteGenerator", () {
    test(
      ".generateRoute() throws an AssertionError if the settings is null",
      () {
        expect(
          () => RouteGenerator.generateRoute(settings: null),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      ".generateRoute() generates a route to the login page if a user is not logged in",
      () {
        final MetricsPageRoute route = RouteGenerator.generateRoute(
          settings: const RouteSettings(name: RouteName.login),
          isLoggedIn: false,
        );

        expect(route.settings.name, equals(RouteName.login));
      },
    );

    test(
      ".generateRoute() generates a route to the debug menu page if a user is logged in and debug menu is enabled",
      () {
        final MetricsPageRoute route = RouteGenerator.generateRoute(
          settings: const RouteSettings(name: RouteName.debugMenu),
          isLoggedIn: true,
          isDebugMenuEnabled: true,
        );

        expect(route.settings.name, equals(RouteName.debugMenu));
      },
    );

    test(
      ".generateRoute() does not generate a route to the debug menu page if a user is logged in and debug menu is not enabled",
      () {
        final MetricsPageRoute route = RouteGenerator.generateRoute(
          settings: const RouteSettings(name: RouteName.debugMenu),
          isLoggedIn: true,
          isDebugMenuEnabled: false,
        );

        expect(route.settings.name, isNot(RouteName.debugMenu));
      },
    );

    test(
      ".generateRoute() generates a route to the dashboard page if a user is logged in",
      () {
        final MetricsPageRoute route = RouteGenerator.generateRoute(
          settings: const RouteSettings(name: RouteName.login),
          isLoggedIn: true,
        );

        expect(route.settings.name, equals(RouteName.dashboard));
      },
    );

    test(
      ".generateRoute() generates a route to the dashboard page if an unknown route is passed",
      () {
        final MetricsPageRoute route = RouteGenerator.generateRoute(
          settings: const RouteSettings(name: '/wrongRoute'),
          isLoggedIn: true,
        );

        expect(route.settings.name, equals(RouteName.dashboard));
      },
    );

    test(
      ".generateRoute() generates a route to the project groups page if a route name is projectGroups",
      () {
        final MetricsPageRoute route = RouteGenerator.generateRoute(
          settings: const RouteSettings(name: RouteName.projectGroup),
          isLoggedIn: true,
        );

        expect(route.settings.name, equals(RouteName.projectGroup));
      },
    );
  });
}
