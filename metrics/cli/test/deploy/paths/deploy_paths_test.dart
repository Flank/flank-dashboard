// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/deploy/paths/deploy_paths.dart';
import 'package:test/test.dart';

void main() {
  group('DeployPaths', () {
    const suffix = 'suffix';
    const tempDir = 'tempDir';

    test(
      ".tempDir() returns a name that contains the given suffix",
      () {
        expect(DeployPaths.tempDir(suffix), contains(suffix));
      },
    );

    test(
      ".webPath() returns a path to the Web project sources that contains the temporary directory",
      () {
        expect(DeployPaths.web(tempDir), contains(tempDir));
      },
    );

    test(
      ".firebasePath() returns a path to the Firebase sources that contains the temporary directory",
      () {
        expect(DeployPaths.firebase(tempDir), contains(tempDir));
      },
    );

    test(
      ".firebaseFunctionsPath() returns a path to the Firebase functions sources that contains the temporary directory",
      () {
        expect(
          DeployPaths.firebaseFunctions(tempDir),
          contains(tempDir),
        );
      },
    );

    test(
      ".metricsConfigPath() returns a path to the Metrics configuration that contains the temporary directory",
      () {
        expect(DeployPaths.metricsConfig(tempDir), contains(tempDir));
      },
    );
  });
}
