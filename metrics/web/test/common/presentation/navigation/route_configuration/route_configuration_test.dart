// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/common/presentation/navigation/route_configuration/route_configuration.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_name.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matchers.dart';

void main() {
  group("RouteConfiguration", () {
    const parameters = {'test': 'test'};

    test(
      ".loading() creates an instance with the name equal to the loading route name",
      () {
        const configuration = RouteConfiguration.loading();
        const expectedName = RouteName.loading;

        expect(configuration.name, equals(expectedName));
      },
    );

    test(
      "equals to another RouteConfiguration with the same parameters",
      () {
        final configuration = RouteConfiguration.dashboard(
          parameters: parameters,
        );

        final anotherConfiguration = RouteConfiguration.dashboard(
          parameters: parameters,
        );

        expect(configuration, equals(anotherConfiguration));
      },
    );

    test(
      ".copyWith() creates a new instance with the same fields if called without parameters",
      () {
        final configuration = RouteConfiguration.dashboard(
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

        final configuration = RouteConfiguration.dashboard(
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
