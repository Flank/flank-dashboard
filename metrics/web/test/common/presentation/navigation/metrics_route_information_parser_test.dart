import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/navigation/constants/metrics_routes.dart';
import 'package:metrics/common/presentation/navigation/metrics_route_information_parser.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_configuration_factory.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';

// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

void main() {
  group("MetricsRouteInformationParser", () {
    final routeConfigurationFactoryMock = _RouteConfigurationFactoryMock();
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
      ".parseRouteInformation() calls the .create() method of the route configuration factory",
      () async {
        final metricsRouteInformationParser = MetricsRouteInformationParser(
          routeConfigurationFactoryMock,
        );

        final routeInformation = RouteInformation(location: 'test');

        await metricsRouteInformationParser.parseRouteInformation(
          routeInformation,
        );

        verify(routeConfigurationFactoryMock.create(any)).called(equals(1));
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

class _RouteConfigurationFactoryMock extends Mock
    implements RouteConfigurationFactory {}
