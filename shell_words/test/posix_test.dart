// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:shell_words/src/posix.dart';
import 'package:test/test.dart';

void main() {
  group('splitPosix', () {
    test('splitPosix case 1', () {
      expect(splitPosix('true').words, ['true']);
    });

    test('splitPosix case 2', () {
      expect(splitPosix('simple --string "quoted"').words,
          ['simple', '--string', 'quoted']);
    });

    test('splitPosix case 3', () {
      expect(splitPosix(r"""\\\""quoted" llamas 'test\''""").words,
          [r'\"quoted', 'llamas', "test'"]);
    });

    test('splitPosix case 4', () {
      expect(
          splitPosix(
                  r'''/usr/bin/bash -e -c "llamas are the \"best\" && echo 'alpacas'"''')
              .words,
          [
            '/usr/bin/bash',
            '-e',
            '-c',
            """llamas are the "best" && echo 'alpacas'"""
          ]);
    });

    test('splitPosix case 5', () {
      expect(splitPosix(r'''"/bin"/ba'sh' -c echo\ \\\\"fo real"''').words,
          ['/bin/bash', '-c', r'echo \\fo real']);
    });

    test('splitPosix case 6', () {
      expect(splitPosix(r"echo 'abc'\''abc'").words, ['echo', "abc'abc"]);
    });

    test('splitPosix case 7', () {
      expect(splitPosix(r'echo "abc"\""abc"').words, ['echo', 'abc"abc']);
    });
  });

  group('quotePosix', () {
    test('quotePosix case 1', () {
      expect(quotePosix('nothing_needed'), 'nothing_needed');
    });

    test('quotePosix case 2', () {
      expect(quotePosix('/bin/bash'), '/bin/bash');
    });

    test('quotePosix case 3', () {
      expect(quotePosix(r'C:\bin\bash'), r'C:\\bin\\bash');
    });

    test('quotePosix case 4', () {
      expect(quotePosix('this has spaces'), '"this has spaces"');
    });

    test('quotePosix case 5', () {
      expect(quotePosix(r'this has $pace$'), r'"this has \$pace\$"');
    });
  });

  group('errorCaseSplitBatch', () {
    test('splitBatch case error case 1', () {
      expect(
          splitPosix(
                  r'"\\vmware-host\Shared Folders\src\github.com\buildkite\agent\llamas @% test\buildkite-agent.exe" "start')
              .error,
          'Expected closing quote " at offset 102, got EOF');
    });

    test('splitBatch case error case 2', () {
      expect(splitPosix(r'simple --string ""quo""ted"').error,
          'Expected closing quote " at offset 26, got EOF');
    });

    test('splitBatch case error case 3', () {
      expect(splitPosix(r"echo ^^^^^&'").error,
          "Expected closing quote ' at offset 11, got EOF");
    });
  });
}
