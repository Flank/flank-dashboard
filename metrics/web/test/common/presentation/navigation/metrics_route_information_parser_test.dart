import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/navigation/constants/metrics_routes.dart';
import 'package:metrics/common/presentation/navigation/metrics_route_information_parser.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_configuration_factory.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_name.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';

// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

void main() {
  group("MetricsRouteInformationParser", () {
    final metricsRouteInformationParser = MetricsRouteInformationParser(
      RouteConfigurationFactory(),
    );

    test(
      "throws an AssertionError if the given route configuration factory is null",
      () {
        expect(
          () => MetricsRouteInformationParser(null),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      ".parseRouteInformation() creates the loading route configuration if the given route information is null",
      () async {
        final actualConfiguration =
            await metricsRouteInformationParser.parseRouteInformation(null);

        expect(actualConfiguration.name, equals(RouteName.loading));
      },
    );

    test(
      ".parseRouteInformation() creates the loading route configuration if the given route information location is null",
      () async {
        final routeInformation = RouteInformation(location: null);

        final actualConfiguration = await metricsRouteInformationParser
            .parseRouteInformation(routeInformation);

        expect(actualConfiguration.name, equals(RouteName.loading));
      },
    );

    test(
      ".parseRouteInformation() creates the login route configuration if the route information location is a login",
      () async {
        final expectedConfiguration = MetricsRoutes.login;
        final routeInformation = RouteInformation(
          location: expectedConfiguration.path,
        );

        final actualConfiguration = await metricsRouteInformationParser
            .parseRouteInformation(routeInformation);

        expect(actualConfiguration, equals(expectedConfiguration));
      },
    );

    test(
      ".parseRouteInformation() creates the dashboard route configuration if the route information location is a dashboard",
      () async {
        final expectedConfiguration = MetricsRoutes.dashboard;
        final routeInformation = RouteInformation(
          location: expectedConfiguration.path,
        );

        final actualConfiguration = await metricsRouteInformationParser
            .parseRouteInformation(routeInformation);

        expect(actualConfiguration, equals(expectedConfiguration));
      },
    );

    test(
      ".parseRouteInformation() creates the project groups route configuration if the route information location is project groups",
      () async {
        final expectedConfiguration = MetricsRoutes.projectGroups;
        final routeInformation = RouteInformation(
          location: expectedConfiguration.path,
        );

        final actualConfiguration = await metricsRouteInformationParser
            .parseRouteInformation(routeInformation);

        expect(actualConfiguration, equals(expectedConfiguration));
      },
    );

    test(
      ".parseRouteInformation() creates the debug menu route configuration if the route information location is a debug menu",
      () async {
        final expectedConfiguration = MetricsRoutes.debugMenu;
        final routeInformation = RouteInformation(
          location: expectedConfiguration.path,
        );

        final actualConfiguration = await metricsRouteInformationParser
            .parseRouteInformation(routeInformation);

        expect(actualConfiguration, equals(expectedConfiguration));
      },
    );

    test(
      ".restoreRouteInformation() returns null if the the given route configuration is null",
      () {
        expect(
          metricsRouteInformationParser.restoreRouteInformation(null),
          isNull,
        );
      },
    );

    test(
      ".restoreRouteInformation() returns the route information with the location equals to the given login route configuration path",
      () {
        final routeConfiguration = MetricsRoutes.login;
        final expectedLocation = routeConfiguration.path;

        final actualLocation = metricsRouteInformationParser
            .restoreRouteInformation(routeConfiguration)
            .location;

        expect(actualLocation, equals(expectedLocation));
      },
    );

    test(
      ".restoreRouteInformation() returns the route information with the location equals to the given dashboard route configuration path",
      () {
        final routeConfiguration = MetricsRoutes.dashboard;
        final expectedLocation = routeConfiguration.path;

        final actualLocation = metricsRouteInformationParser
            .restoreRouteInformation(routeConfiguration)
            .location;

        expect(actualLocation, equals(expectedLocation));
      },
    );

    test(
      ".restoreRouteInformation() returns the route information with the location equals to the given project groups route configuration path",
      () {
        final routeConfiguration = MetricsRoutes.projectGroups;
        final expectedLocation = routeConfiguration.path;

        final actualLocation = metricsRouteInformationParser
            .restoreRouteInformation(routeConfiguration)
            .location;

        expect(actualLocation, equals(expectedLocation));
      },
    );

    test(
      ".restoreRouteInformation() returns the route information with the location equals to the given debug menu route configuration path",
      () {
        final routeConfiguration = MetricsRoutes.debugMenu;
        final expectedLocation = routeConfiguration.path;

        final actualLocation = metricsRouteInformationParser
            .restoreRouteInformation(routeConfiguration)
            .location;

        expect(actualLocation, equals(expectedLocation));
      },
    );
  });
}
