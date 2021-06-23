// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/common/model/paths.dart';
import 'package:cli/common/model/factory/paths_factory.dart';
import 'package:test/test.dart';

void main() {
  group("DeployPathsFactory", () {
    const rootPath = 'rootPath';
    final deployPathsFactory = PathsFactory();

    test(
      ".create() successfully creates a DeployPaths instance",
      () {
        final deployPaths = deployPathsFactory.create(rootPath);

        expect(deployPaths, isA<Paths>());
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
