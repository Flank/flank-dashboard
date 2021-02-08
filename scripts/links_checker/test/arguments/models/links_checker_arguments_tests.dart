// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:links_checker/arguments/models/links_checker_arguments.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("LinksCheckerArguments", () {
    test(
      "throws an ArgumentError if paths value is null",
      () {
        expect(() => LinksCheckerArguments(paths: null), throwsArgumentError);
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        const paths = ['1 2'];
        final arguments = LinksCheckerArguments(paths: paths);

        expect(arguments.paths, equals(paths));
      },
    );
  });
}
