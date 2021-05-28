// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:links_checker/checker/error/links_checker_error.dart';
import 'package:links_checker/checker/links_checker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  group("LinksChecker", () {
    const urls = [
      'http://raw.githubusercontent.com/Flank/flank-dashboard',
      'http://github.com/Flank/flank-dashboard/blob',
      'http://github.com/Flank/flank-dashboard/tree',
      'http://github.com/Flank/flank-dashboard/raw',
      'http://raw.com',
      'https://raw.githubusercontent.com/Flank/flank-dashboard',
      'https://github.com/Flank/flank-dashboard/blob',
      'https://github.com/Flank/flank-dashboard/tree',
      'https://github.com/Flank/flank-dashboard/raw',
      'https://raw.com',
    ];
    const validSuffix = 'master/';
    const invalidSuffix = 'invalid/';
    const validLikeSuffix = 'master_like/';

    final linksChecker = LinksChecker(urls);
    final file = _FileMock();
    final files = <File>[file];

    tearDown(() {
      reset(file);
    });

    test(
      ".checkFiles() returns normally if the given files contain only valid links",
      () {
        final validUrls = urls.map((url) => '$url/$validSuffix').join(',');

        when(file.readAsStringSync()).thenReturn(validUrls);

        expect(() => linksChecker.checkFiles(files), returnsNormally);
      },
    );

    test(
      ".checkFiles() throws a LinksCheckerError if the given files contain invalid links",
      () {
        final invalidUrls = urls.map((url) => '$url/$invalidSuffix').join(',');

        when(file.readAsStringSync()).thenReturn(invalidUrls);

        expect(
          () => linksChecker.checkFiles(files),
          throwsA(isA<LinksCheckerError>()),
        );
      },
    );

    test(
      ".checkFiles() throws a LinksCheckerError if the given files contain master-like links",
      () {
        final masterLikeUrls =
            urls.map((url) => '$url/$validLikeSuffix').join(',');

        when(file.readAsStringSync()).thenReturn(masterLikeUrls);

        expect(
          () => linksChecker.checkFiles(files),
          throwsA(isA<LinksCheckerError>()),
        );
      },
    );
  });
}

class _FileMock extends Mock implements File {}
