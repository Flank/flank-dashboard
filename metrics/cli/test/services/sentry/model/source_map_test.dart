// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/services/sentry/model/source_map.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("SourceMap", () {
    const path = 'path';
    const extensions = ['dart', 'js'];

    test(
      "throws an ArgumentError if the given path is null",
      () {
        expect(
          () => SourceMap(path: null, extensions: extensions),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given extensions are null",
      () {
        expect(
          () => SourceMap(path: path, extensions: null),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        final sourceMap = SourceMap(path: path, extensions: extensions);

        expect(sourceMap.path, equals(path));
        expect(sourceMap.extensions, equals(extensions));
      },
    );

    test(
      "equals to another SourceMap with the same parameters",
      () {
        final expected = SourceMap(path: path, extensions: extensions);
        final sourceMap = SourceMap(path: path, extensions: extensions);

        expect(sourceMap, equals(expected));
      },
    );
  });
}
