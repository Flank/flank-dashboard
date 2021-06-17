// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/navigation/constants/default_routes.dart';
import 'package:metrics/common/presentation/navigation/metrics_route_information_parser.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_configuration_factory.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_configuration_location_converter.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../test_utils/matchers.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("MetricsRouteInformationParser", () {
    final routeConfiguration = DefaultRoutes.login;
    final routeConfigurationFactory = _RouteConfigurationFactoryMock();
    final locationConverter = _RouteConfigurationLocationConverterMock();
    final routeInformationParser = MetricsRouteInformationParser(
      routeConfigurationFactory: routeConfigurationFactory,
      locationConverter: locationConverter,
    );

    tearDown(() {
      reset(routeConfigurationFactory);
      reset(locationConverter);
    });

    test(
      "successfully creates an instance if the given route configuration factory is null",
      () {
        expect(
          () => MetricsRouteInformationParser(
            routeConfigurationFactory: null,
            locationConverter: locationConverter,
          ),
          returnsNormally,
        );
      },
    );

    test(
      "successfully creates an instance if the given route configuration location converter is null",
      () {
        expect(
          () => MetricsRouteInformationParser(
            routeConfigurationFactory: routeConfigurationFactory,
            locationConverter: null,
          ),
          returnsNormally,
        );
      },
    );

    test(
      ".parseRouteInformation() delegates to the route configuration factory if the given route information is null",
      () async {
        await routeInformationParser.parseRouteInformation(null);

        verify(routeConfigurationFactory.create(null)).called(once);
      },
    );

    test(
      ".parseRouteInformation() delegates to the route configuration factory if the location of the given route information is null",
      () async {
        await routeInformationParser.parseRouteInformation(
          const RouteInformation(location: null),
        );

        verify(routeConfigurationFactory.create(null)).called(once);
      },
    );

    test(
      ".parseRouteInformation() returns the route configuration created by the given route configuration factory",
      () async {
        final expectedConfiguration = DefaultRoutes.dashboard;

        when(
          routeConfigurationFactory.create(any),
        ).thenReturn(expectedConfiguration);

        final actualConfiguration =
            await routeInformationParser.parseRouteInformation(
          const RouteInformation(location: 'test'),
        );

        expect(actualConfiguration, equals(expectedConfiguration));
      },
    );

    test(
      ".restoreRouteInformation() returns null if the the given route configuration is null",
      () {
        expect(
          routeInformationParser.restoreRouteInformation(null),
          isNull,
        );
      },
    );

    test(
      ".restoreRouteInformation() delegates converting the route configuration to the route configuration location converter if the configuration is not null",
      () {
        routeInformationParser.restoreRouteInformation(routeConfiguration);

        verify(locationConverter.convert(routeConfiguration)).called(once);
      },
    );

    test(
      ".restoreRouteInformation() returns the route information with the location returned by the route configuration location converter",
      () {
        const expectedLocation = 'location';
        when(
          locationConverter.convert(routeConfiguration),
        ).thenReturn(expectedLocation);

        final routeInformation = routeInformationParser.restoreRouteInformation(
          routeConfiguration,
        );
        final actualLocation = routeInformation.location;

        expect(actualLocation, equals(expectedLocation));
      },
    );
  });
}

class _RouteConfigurationFactoryMock extends Mock
    implements RouteConfigurationFactory {}

class _RouteConfigurationLocationConverterMock extends Mock
    implements RouteConfigurationLocationConverter {}
