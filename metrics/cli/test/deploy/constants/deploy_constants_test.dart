// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/deploy/constants/deploy_constants.dart';
import 'package:test/test.dart';

void main() {
  group('DeployConstants', () {
    const suffix = 'suffix';
    const tempDir = 'tempDir';

    test(
      ".tempDir() returns a name if the given suffix is null",
      () {
        expect(DeployConstants.tempDir(), isNotNull);
      },
    );

    test(
      ".tempDir() returns a name that contains the given suffix",
      () {
        expect(DeployConstants.tempDir(suffix), contains(suffix));
      },
    );

    test(
      ".webPath() returns a path to the Web project sources that contains the temporary directory",
      () {
        expect(DeployConstants.webPath(tempDir), contains(tempDir));
      },
    );

    test(
      ".firebasePath() returns a path to the Firebase sources that contains the temporary directory",
      () {
        expect(DeployConstants.firebasePath(tempDir), contains(tempDir));
      },
    );

    test(
      ".firebaseFunctionsPath() returns a path to the Firebase functions sources that contains the temporary directory",
      () {
        expect(
          DeployConstants.firebaseFunctionsPath(tempDir),
          contains(tempDir),
        );
      },
    );

    test(
      ".metricsConfigPath() returns a path to the Metrics configuration that contains the temporary directory",
      () {
        expect(DeployConstants.metricsConfigPath(tempDir), contains(tempDir));
      },
    );
  });
}
