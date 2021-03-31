// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

// ignore_for_file: avoid_redundant_argument_values

import 'package:cli/common/factory/services_factory.dart';
import 'package:cli/common/model/services.dart';
import 'package:cli/deploy/deployer.dart';
import 'package:cli/deploy/factory/deployer_factory.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../test_utils/matchers.dart';

void main() {
  group("DeployerFactory", () {
    final servicesFactory = _ServicesFactoryMock();
    final services = _ServicesMock();
    final deployerFactory = DeployerFactory(servicesFactory);

    PostExpectation<Services> whenCreateServices() {
      return when(servicesFactory.create());
    }

    test(
      "throws an ArgumentError if the given services factory is null",
      () {
        expect(
          () => DeployerFactory(null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".create() creates a Services instance using the given services factory",
      () {
        whenCreateServices().thenReturn(services);

        deployerFactory.create();

        verify(servicesFactory.create()).called(once);
      },
    );

    test(
      ".create() successfully creates a Deployer instance",
      () {
        whenCreateServices().thenReturn(services);

        final deployer = deployerFactory.create();

        expect(deployer, isA<Deployer>());
      },
    );
  });
}

class _ServicesFactoryMock extends Mock implements ServicesFactory {}

class _ServicesMock extends Mock implements Services {}
