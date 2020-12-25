import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/navigation/constants/metrics_routes.dart';
import 'package:metrics/common/presentation/navigation/metrics_page/metrics_page_route.dart';
import 'package:metrics/common/presentation/routes/route_generator.dart';
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
          settings: RouteSettings(name: MetricsRoutes.login.path),
          isLoggedIn: false,
        );

        expect(route.settings.name, equals(MetricsRoutes.login.path));
      },
    );

    test(
      ".generateRoute() generates a route to the dashboard page if a user is logged in",
      () {
        final MetricsPageRoute route = RouteGenerator.generateRoute(
          settings: RouteSettings(name: MetricsRoutes.login.path),
          isLoggedIn: true,
        );

        expect(route.settings.name, equals(MetricsRoutes.dashboard.path));
      },
    );

    test(
      ".generateRoute() generates a route to the dashboard page if an unknown route is passed",
      () {
        final MetricsPageRoute route = RouteGenerator.generateRoute(
          settings: const RouteSettings(name: '/wrongRoute'),
          isLoggedIn: true,
        );

        expect(route.settings.name, equals(MetricsRoutes.dashboard.path));
      },
    );

    test(
      ".generateRoute() generates a route to the project groups page if a route name is projectGroups",
      () {
        final MetricsPageRoute route = RouteGenerator.generateRoute(
          settings: RouteSettings(name: MetricsRoutes.projectGroups.path),
          isLoggedIn: true,
        );

        expect(route.settings.name, equals(MetricsRoutes.projectGroups.path));
      },
    );

    test(
      ".generateRoute() generates a route to the debug menu page if a route name is debugMenu",
      () {
        final MetricsPageRoute route = RouteGenerator.generateRoute(
          settings: RouteSettings(name: MetricsRoutes.debugMenu.path),
          isLoggedIn: true,
        );

        expect(route.settings.name, equals(MetricsRoutes.debugMenu.path));
      },
    );
  });
}
