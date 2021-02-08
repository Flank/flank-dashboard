// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/common/presentation/navigation/constants/metrics_routes.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_configuration_factory.dart';
import 'package:test/test.dart';

void main() {
  group("RouteConfigurationFactory", () {
    const baseUrl = 'https://test.uri';
    final routeConfigurationFactory = RouteConfigurationFactory();

    test(
      ".create() returns a loading route configuration if the given uri is null",
      () {
        final configuration = routeConfigurationFactory.create(null);

        expect(configuration, equals(MetricsRoutes.loading));
      },
    );

    test(
      ".create() returns a loading route configuration if the given uri does not contain the path",
      () {
        final uri = Uri.parse(baseUrl);

        final configuration = routeConfigurationFactory.create(uri);

        expect(configuration, equals(MetricsRoutes.loading));
      },
    );

    test(
      ".create() returns a login route configuration if the given uri contains login path",
      () {
        final uri = Uri.parse('$baseUrl${MetricsRoutes.login.path}');

        final configuration = routeConfigurationFactory.create(uri);

        expect(configuration, equals(MetricsRoutes.login));
      },
    );

    test(
      ".create() returns a dashboard route configuration if the given uri contains dashboard path",
      () {
        final uri = Uri.parse('$baseUrl${MetricsRoutes.dashboard.path}');

        final configuration = routeConfigurationFactory.create(uri);

        expect(configuration, equals(MetricsRoutes.dashboard));
      },
    );

    test(
      ".create() returns a project groups route configuration if the given uri contains project groups path",
      () {
        final uri = Uri.parse('$baseUrl${MetricsRoutes.projectGroups.path}');

        final configuration = routeConfigurationFactory.create(uri);

        expect(configuration, equals(MetricsRoutes.projectGroups));
      },
    );

    test(
      ".create() returns a debug menu route configuration if the given uri contains debug menu path",
      () {
        final uri = Uri.parse('$baseUrl${MetricsRoutes.debugMenu.path}');

        final configuration = routeConfigurationFactory.create(uri);

        expect(configuration, equals(MetricsRoutes.debugMenu));
      },
    );


    test(
      ".create() returns a dashboard route configuration if the given uri contains an unknown path",
      () {
        final uri = Uri.parse('$baseUrl/path');

        final configuration = routeConfigurationFactory.create(uri);

        expect(configuration, equals(MetricsRoutes.dashboard));
      },
    );
  });
}
