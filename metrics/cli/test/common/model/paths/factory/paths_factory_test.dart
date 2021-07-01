// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/common/model/paths/paths.dart';
import 'package:cli/common/model/paths/factory/paths_factory.dart';
import 'package:test/test.dart';

void main() {
  group("PathsFactory", () {
    const rootPath = 'rootPath';
    final pathsFactory = PathsFactory();

    test(
      ".create() successfully creates a Paths instance",
      () {
        final paths = pathsFactory.create(rootPath);

        expect(paths, isA<Paths>());
      },
    );

    test(
      ".create() creates a Paths instance with the given root path",
      () {
        final paths = pathsFactory.create(rootPath);

        expect(paths.rootPath, equals(rootPath));
      },
    );
  });
}
