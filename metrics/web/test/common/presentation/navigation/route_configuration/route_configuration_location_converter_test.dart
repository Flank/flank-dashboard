// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/common/presentation/navigation/route_configuration/route_configuration_location_converter.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../test_utils/route_configuration_mock.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("RouteConfigurationLocationConverter", () {
    const path = '/test';
    const locationConverter = RouteConfigurationLocationConverter();

    final routeConfiguration = RouteConfigurationMock();

    tearDown((){
      reset(routeConfiguration);
    });

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
        when(routeConfiguration.path).thenReturn(path);

        final result = locationConverter.convert(routeConfiguration);

        expect(result, startsWith(path));
      },
    );

    test(
      ".convert() returns a location that equals to the given route configuration's path if the given route configuration's parameters map is null",
      () {
        when(routeConfiguration.path).thenReturn(path);
        when(routeConfiguration.parameters).thenReturn(null);

        final result = locationConverter.convert(routeConfiguration);

        expect(result, equals(path));
      },
    );

    test(
      ".convert() returns a location that equals to the given route configuration's path if the given route configuration's parameters map is empty",
      () {
        when(routeConfiguration.path).thenReturn(path);
        when(routeConfiguration.parameters).thenReturn(const {});


        final result = locationConverter.convert(routeConfiguration);

        expect(result, equals(path));
      },
    );

    test(
      ".convert() returns a location containing the given route configuration's path and parameters as query parameters",
      () {
        const path = '/test';
        const parameters = {'test': 'test'};
        const expectedLocation = '/test?test=test';

        when(routeConfiguration.path).thenReturn(path);
        when(routeConfiguration.parameters).thenReturn(parameters);


        final result = locationConverter.convert(routeConfiguration);

        expect(result, equals(expectedLocation));
      },
    );
  });
}
