import 'package:metrics/common/presentation/navigation/route_configuration/route_configuration.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_name.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matcher_util.dart';

// ignore_for_file: prefer_const_constructors

void main() {
  group("RouteConfiguration", () {
    test(
      "throws an AssertionError if the given name is null",
      () {
        expect(
          () => RouteConfiguration(name: null, authorizationRequired: true),
          MatcherUtil.throwsAssertionError,
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
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        const name = RouteName.login;
        const path = 'test_path';
        const authorizationRequired = false;

        final configuration = RouteConfiguration(
          name: name,
          path: path,
          authorizationRequired: authorizationRequired,
        );

        expect(configuration.name, equals(name));
        expect(configuration.path, equals(path));
        expect(
          configuration.authorizationRequired,
          equals(authorizationRequired),
        );
      },
    );
  });
}
