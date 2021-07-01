// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/common/model/paths.dart';
import 'package:test/test.dart';

void main() {
  group('Paths', () {
    const rootPath = 'rootPath';

    final paths = Paths(rootPath);

    test(
      "throws an ArgumentError if the given root path is null",
      () {
        expect(() => Paths(null), throwsArgumentError);
      },
    );

    test(
      ".webAppPath returns a path that contains the root path",
      () {
        expect(paths.webAppPath, contains(rootPath));
      },
    );

    test(
      ".webAppBuildPath returns a path to the Web project sources that contains the root path",
      () {
        expect(paths.webAppBuildPath, contains(rootPath));
      },
    );

    test(
      ".firebasePath returns a path to the Firebase sources that contains the root path",
      () {
        expect(paths.firebasePath, contains(rootPath));
      },
    );

    test(
      ".firebaseFunctionsPath returns a path to the Firebase functions sources that contains the root path",
      () {
        expect(
          paths.firebaseFunctionsPath,
          contains(rootPath),
        );
      },
    );

    test(
      ".metricsConfigPath returns a path to the Metrics configuration that contains the root path",
      () {
        expect(paths.metricsConfigPath, contains(rootPath));
      },
    );
  });
}
