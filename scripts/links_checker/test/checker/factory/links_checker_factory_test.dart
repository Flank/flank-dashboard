// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:links_checker/checker/factory/links_checker_factory.dart';
import 'package:links_checker/checker/links_checker.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("LinksCheckerFactory", () {
    const factory = LinksCheckerFactory();

    test(
      ".create() throws an ArgumentError if the given repository is null",
      () {
        expect(() => factory.create(null), throwsArgumentError);
      },
    );

    test(
      ".create() returns a links checker with the prefixes containing the given repository",
      () {
        const repository = 'owner/repository';
        const expectedPrefixes = [
          'raw.githubusercontent.com/$repository',
          'github.com/$repository/blob',
          'github.com/$repository/raw',
          'github.com/$repository/tree',
        ];

        final linksChecker = factory.create(repository);

        expect(linksChecker, isA<LinksChecker>());
        expect(linksChecker.repositoryPrefixes, equals(expectedPrefixes));
      },
    );
  });
}
