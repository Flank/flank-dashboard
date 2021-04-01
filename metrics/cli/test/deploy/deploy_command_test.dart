// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/deploy/deploy_command.dart';
import 'package:cli/deploy/deployer.dart';
import 'package:cli/deploy/factory/deployer_factory.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../test_utils/matchers.dart';

void main() {
  group("DeployCommand", () {
    final deployerFactory = _DeployerFactoryMock();
    final deployer = _DeployerMock();
    final deployCommand = DeployCommand(deployerFactory);

    PostExpectation<Deployer> whenDeployerFactoryCreate() {
      return when(deployerFactory.create());
    }

    tearDown(() {
      reset(deployerFactory);
      reset(deployer);
    });

    test(
      "throws an ArgumentError if the given deployer factory is null",
      () {
        expect(
          () => DeployCommand(null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".name equals to the 'deploy'",
      () {
        expect(deployCommand.name, equals('deploy'));
      },
    );

    test(
      ".description is not empty",
      () {
        final description = deployCommand.description;

        expect(description, isNotEmpty);
      },
    );

    test(
      ".run() creates deployer using the given deployer factory",
      () async {
        whenDeployerFactoryCreate().thenReturn(deployer);

        await deployCommand.run();

        verify(deployerFactory.create()).called(once);
      },
    );

    test(
      ".run() uses the deployer to deploy the web application",
      () async {
        whenDeployerFactoryCreate().thenReturn(deployer);

        await deployCommand.run();

        verify(deployer.deploy()).called(once);
      },
    );
  });
}

class _DeployerMock extends Mock implements Deployer {}

class _DeployerFactoryMock extends Mock implements DeployerFactory {}
