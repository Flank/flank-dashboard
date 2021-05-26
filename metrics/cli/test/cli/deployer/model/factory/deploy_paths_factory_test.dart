// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/cli/deployer/model/deploy_paths.dart';
import 'package:cli/cli/deployer/model/factory/deploy_paths_factory.dart';
import 'package:test/test.dart';

void main() {
  group("DeployPathsFactory", () {
    const rootPath = 'rootPath';
    final deployPathsFactory = DeployPathsFactory();

    test(
      ".create() successfully creates a DeployPaths instance",
      () {
        final deployPaths = deployPathsFactory.create(rootPath);

        expect(deployPaths, isA<DeployPaths>());
      },
    );

    test(
      ".create() creates a DeployPaths instance with the given root path",
      () {
        final deployPaths = deployPathsFactory.create(rootPath);

        expect(deployPaths.rootPath, equals(rootPath));
      },
    );
  });
}
