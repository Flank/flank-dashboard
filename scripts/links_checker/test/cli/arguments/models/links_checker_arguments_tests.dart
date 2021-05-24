// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:links_checker/cli/arguments/models/links_checker_arguments.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("LinksCheckerArguments", () {
    const paths = ['1 2'];
    const ignore = ['2 3'];
    const repository = 'owner/repository';

    test(
      "throws an ArgumentError if the given repository is null",
      () {
        expect(
          () => LinksCheckerArguments(repository: null, paths: paths),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given paths value is null",
      () {
        expect(
          () => LinksCheckerArguments(repository: repository, paths: null),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        final arguments = LinksCheckerArguments(
          repository: repository,
          paths: paths,
          ignorePaths: ignore,
        );

        expect(arguments.repository, equals(repository));
        expect(arguments.paths, equals(paths));
        expect(arguments.ignorePaths, equals(ignore));
      },
    );
  });
}
