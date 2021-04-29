// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/deploy/paths/deploy_paths.dart';
import 'package:test/test.dart';

void main() {
  group('DeployPaths', () {
    const path = 'tempDirPath';

    final deployPaths = DeployPaths();

    test(
      ".initTempDirectoryPath() throws an ArgumentError if the given path is null",
      () {
        expect(
          () => deployPaths.initTempDirectoryPath(null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".web returns a name that contains the initialized temporary path",
      () {
        deployPaths.initTempDirectoryPath(path);

        expect(deployPaths.web, contains(path));
      },
    );

    test(
      ".buildWeb returns a path to the Web project sources that contains the initialized temporary path",
      () {
        deployPaths.initTempDirectoryPath(path);

        expect(deployPaths.buildWeb, contains(path));
      },
    );

    test(
      ".firebase returns a path to the Firebase sources that contains the initialized temporary path",
      () {
        deployPaths.initTempDirectoryPath(path);

        expect(deployPaths.firebase, contains(path));
      },
    );

    test(
      ".firebaseFunctions returns a path to the Firebase functions sources that contains the initialized temporary path",
      () {
        deployPaths.initTempDirectoryPath(path);

        expect(
          deployPaths.firebaseFunctions,
          contains(path),
        );
      },
    );

    test(
      ".metricsConfig returns a path to the Metrics configuration that contains the initialized temporary path",
      () {
        deployPaths.initTempDirectoryPath(path);

        expect(deployPaths.metricsConfig, contains(path));
      },
    );
  });
}
