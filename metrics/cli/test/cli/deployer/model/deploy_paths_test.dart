// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/cli/deployer/model/deploy_paths.dart';
import 'package:test/test.dart';

void main() {
  group('DeployPaths', () {
    const rootPath = 'rootPath';

    final deployPaths = DeployPaths(rootPath);

    test(
      "throws an ArgumentError if the given root path is null",
      () {
        expect(() => DeployPaths(null), throwsArgumentError);
      },
    );

    test(
      ".webAppPath returns a path that contains the root path",
      () {
        expect(deployPaths.webAppPath, contains(rootPath));
      },
    );

    test(
      ".webAppBuildPath returns a path to the Web project sources that contains the root path",
      () {
        expect(deployPaths.webAppBuildPath, contains(rootPath));
      },
    );

    test(
      ".firebasePath returns a path to the Firebase sources that contains the root path",
      () {
        expect(deployPaths.firebasePath, contains(rootPath));
      },
    );

    test(
      ".firebaseFunctionsPath returns a path to the Firebase functions sources that contains the root path",
      () {
        expect(
          deployPaths.firebaseFunctionsPath,
          contains(rootPath),
        );
      },
    );

    test(
      ".metricsConfigPath returns a path to the Metrics configuration that contains the root path",
      () {
        expect(deployPaths.metricsConfigPath, contains(rootPath));
      },
    );
  });
}
