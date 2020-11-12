import 'dart:io';

import 'package:links_checker/common/checker/links_checker.dart';
import 'package:links_checker/common/exception/links_checker_exception.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  group("LinksChecker", () {
    const validUrl = 'http://github.com/platform-platform/monorepo/blob/master';

    // This link is concatenated because the link check will fail on this link.
    const invalidUrl =
        'http://github.com/platform-platform/monorepo/blob' + '/test';

    final linksChecker = LinksChecker();
    final file = _FileMock();
    final files = <_FileMock>[file];

    tearDown(() {
      reset(file);
    });

    test(
      '.check() returns normally if the given files contain only valid links',
      () {
        when(file.readAsStringSync()).thenReturn(validUrl);

        expect(() => linksChecker.check(files), returnsNormally);
      },
    );

    test(
      ".check() throws a LinksCheckerException if the given files contain invalid links",
      () {
        when(file.readAsStringSync()).thenReturn(invalidUrl);

        expect(
          () => linksChecker.check(files),
          throwsA(isA<LinksCheckerException>()),
        );
      },
    );
  });
}

class _FileMock extends Mock implements File {}
