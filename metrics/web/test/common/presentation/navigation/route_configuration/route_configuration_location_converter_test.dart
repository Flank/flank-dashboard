import 'package:metrics/common/presentation/navigation/route_configuration/route_configuration.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_configuration_location_converter.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_name.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("RouteConfigurationLocationConverter", () {
    const path = '/test';
    const locationConverter = RouteConfigurationLocationConverter();

    RouteConfiguration createRouteConfiguration({
      String path,
      Map<String, dynamic> parameters,
    }) {
      return RouteConfiguration(
        name: RouteName.dashboard,
        authorizationRequired: true,
        path: path,
        parameters: parameters,
      );
    }

    test(
      ".convert() returns null if the given route configuration is null",
      () {
        final result = locationConverter.convert(null);

        expect(result, isNull);
      },
    );

    test(
      ".convert() returns a location that starts with the given route configuration's path",
      () {
        final routeConfiguration = createRouteConfiguration(path: path);

        final result = locationConverter.convert(routeConfiguration);

        expect(result, startsWith(path));
      },
    );

    test(
      ".convert() returns a location that equals to the given route configuration's path if the given route configuration's parameters map is null",
      () {
        final routeConfiguration = createRouteConfiguration(
          path: path,
          parameters: null,
        );

        final result = locationConverter.convert(routeConfiguration);

        expect(result, equals(path));
      },
    );

    test(
      ".convert() returns a location that equals to the given route configuration's path if the given route configuration's parameters map is empty",
      () {
        final routeConfiguration = createRouteConfiguration(
          path: path,
          parameters: const {},
        );

        final result = locationConverter.convert(routeConfiguration);

        expect(result, equals(path));
      },
    );

    test(
      ".convert() returns a location containing the given route configuration's path and parameters as query parameters",
      () {
        const path = '/test';
        const queryParameters = {'test': 'test'};
        const expectedLocation = '/test?test=test';

        final routeConfiguration = createRouteConfiguration(
          path: path,
          parameters: queryParameters,
        );

        final result = locationConverter.convert(routeConfiguration);

        expect(result, equals(expectedLocation));
      },
    );
  });
}
