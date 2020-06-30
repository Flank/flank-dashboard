import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/routes/route_generator.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';

void main() {
  group('RouteGenerator', () {
    test(
      '.generateRoute() throws the AssertionError if the settings is null',
      () {
        expect(
          () => RouteGenerator.generateRoute(settings: null),
          MatcherUtil.throwsAssertionError,
        );
      },
    );
    test(
      '.generateRoute() generates a route to the login page if a user is not logged in',
      () {
        final MaterialPageRoute route = RouteGenerator.generateRoute(
          settings: const RouteSettings(name: RouteGenerator.login),
          isLoggedIn: false,
        );

        expect(route.settings.name, equals(RouteGenerator.login));
      },
    );

    test(
      '.generateRoute() generates a route to the dashboard page if a user is logged in',
      () {
        final MaterialPageRoute route = RouteGenerator.generateRoute(
          settings: const RouteSettings(name: RouteGenerator.login),
          isLoggedIn: true,
        );

        expect(route.settings.name, equals(RouteGenerator.dashboard));
      },
    );

    test(
      '.generateRoute() generates a route to the dashboard page if an unknown route is passed',
      () {
        final MaterialPageRoute route = RouteGenerator.generateRoute(
          settings: const RouteSettings(name: '/wrongRoute'),
          isLoggedIn: true,
        );

        expect(route.settings.name, equals(RouteGenerator.dashboard));
      },
    );

    test(
      '.generateRoute() generates a route to the project groups page if a route name is projectGroups',
      () {
        final MaterialPageRoute route = RouteGenerator.generateRoute(
          settings: const RouteSettings(name: '/projectGroups'),
          isLoggedIn: true,
        );

        expect(route.settings.name, equals(RouteGenerator.projectGroup));
      },
    );
  });
}
