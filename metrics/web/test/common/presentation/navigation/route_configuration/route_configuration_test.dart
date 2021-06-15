// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/common/presentation/navigation/route_configuration/route_configuration.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_name.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matchers.dart';

void main() {
  group("RouteConfiguration", () {
    const name = RouteName.login;
    const path = 'test_path';
    const authorizationRequired = false;
    const parameters = {'test': 'test'};

    test(
      "throws an AssertionError if the given name is null",
      () {
        expect(
          () => RouteConfiguration(name: null, authorizationRequired: true),
          throwsAssertionError,
        );
      },
    );

    test(
      "throws an AssertionError if the given authorization required is null",
      () {
        expect(
          () => RouteConfiguration(
            name: RouteName.login,
            authorizationRequired: null,
          ),
          throwsAssertionError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        const configuration = RouteConfiguration(
          name: name,
          path: path,
          authorizationRequired: authorizationRequired,
          parameters: parameters,
        );

        expect(configuration.name, equals(name));
        expect(configuration.path, equals(path));
        expect(
          configuration.authorizationRequired,
          equals(authorizationRequired),
        );
        expect(configuration.parameters, equals(parameters));
      },
    );

    test(
      "equals to another RouteConfiguration with the same parameters",
      () {
        const configuration = RouteConfiguration(
          name: name,
          path: path,
          authorizationRequired: authorizationRequired,
          parameters: parameters,
        );

        const anotherConfiguration = RouteConfiguration(
          name: name,
          path: path,
          authorizationRequired: authorizationRequired,
          parameters: parameters,
        );

        expect(configuration, equals(anotherConfiguration));
      },
    );

    test(
      ".copyWith() creates a new instance with the same fields if called without parameters",
      () {
        const configuration = RouteConfiguration(
          name: name,
          path: path,
          authorizationRequired: authorizationRequired,
          parameters: parameters,
        );

        final copiedConfiguration = configuration.copyWith();

        expect(configuration, equals(copiedConfiguration));
      },
    );

    test(
      ".copyWith() creates a copy of an instance with the given fields replaced with the new values",
      () {
        const newName = RouteName.dashboard;
        const newPath = 'test_path2';
        const newAuthorizationRequired = true;
        const newParameters = {'test2': 'test2'};

        const configuration = RouteConfiguration(
          name: name,
          path: path,
          authorizationRequired: authorizationRequired,
          parameters: parameters,
        );

        final copiedConfiguration = configuration.copyWith(
          name: newName,
          path: newPath,
          authorizationRequired: newAuthorizationRequired,
          parameters: newParameters,
        );

        expect(copiedConfiguration.name, equals(newName));
        expect(copiedConfiguration.path, equals(newPath));
        expect(
          copiedConfiguration.authorizationRequired,
          equals(newAuthorizationRequired),
        );
        expect(copiedConfiguration.parameters, equals(newParameters));
      },
    );
  });
}
