import 'dart:io';

import 'package:links_checker/common/checker/links_checker.dart';
import 'package:links_checker/common/exception/links_checker_exception.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  group("LinksChecker", () {
    const url = 'http://github.com/platform-platform/monorepo/blob';

    const validUrl = '$url/master/';
    const invalidUrl = '$url/test/';

    final linksChecker = LinksChecker();
    final file = _FileMock();
    final files = <_FileMock>[file];

    tearDown(() {
      reset(file);
    });

    test(
      '.checkFiles() returns normally if the given files contain only valid links',
      () {
        when(file.readAsStringSync()).thenReturn(validUrl);

        expect(() => linksChecker.checkFiles(files), returnsNormally);
      },
    );

    test(
      ".checkFiles() throws a LinksCheckerException if the given files contain invalid links",
      () {
        when(file.readAsStringSync()).thenReturn(invalidUrl);

        expect(
          () => linksChecker.checkFiles(files),
          throwsA(isA<LinksCheckerException>()),
        );
      },
    );
  });
}

class _FileMock extends Mock implements File {}
