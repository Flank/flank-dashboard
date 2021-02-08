// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:shell_words/src/batch.dart';
import 'package:test/test.dart';

void main() {
  group('splitBatch', () {
    test('splitBatch case 1', () {
      expect(
          splitBatch(
                  r'"\\vmware-host\Shared Folders\src\github.com\buildkite\agent\llamas @% test\buildkite-agent.exe" start')
              .words,
          [
            r'\\vmware-host\Shared Folders\src\github.com\buildkite\agent\llamas @% test\buildkite-agent.exe',
            'start'
          ]);
    });

    test('splitBatch case 2', () {
      expect(splitBatch('simple 🙌🏻 --string "quo""ted"').words,
          ['simple', '🙌🏻', '--string', 'quo"ted']);
    });

    test('splitBatch case 3', () {
      expect(splitBatch('simple --string "quo""ted"').words,
          ['simple', '--string', 'quo"ted']);
    });

    test('splitBatch case 4', () {
      expect(splitBatch('mkdir "My favorite "^%OS^%').words,
          ['mkdir', 'My favorite %OS%']);
    });

    test('splitBatch case 5', () {
      expect(
          splitBatch(
                  r'''runme.exe /password:"~!@#$^%^^^&*()_+^|-=\][{}'^;:""/.>?,<"''')
              .words,
          ['runme.exe', r'''/password:~!@#$%^&*()_+|-=\][{}';:"/.>?,<''']);
    });

    test('splitBatch case 6', () {
      expect(splitBatch('echo ^^^^^&').words, ['echo', '^^&']);
    });
  });

  group('quoteBatch', () {
    test('quoteBatch case 1', () {
      expect(quoteBatch('nothing_needed'), 'nothing_needed');
    });

    test('quoteBatch case 2', () {
      expect(quoteBatch(r'C:\bin\bash'), r'C:\bin\bash');
    });

    test('quoteBatch case 3', () {
      expect(quoteBatch(r'C:\Program Files\bin\bash.exe'),
          r'"C:\Program Files\bin\bash.exe"');
    });

    test('quoteBatch case 4', () {
      expect(quoteBatch(r'\\uncpath\My Files\bin\bash.exe'),
          r'"\\uncpath\My Files\bin\bash.exe"');
    });

    test('quoteBatch case 5', () {
      expect(quoteBatch('this has spaces'), '"this has spaces"');
    });

    test('quoteBatch case 6', () {
      expect(quoteBatch(r'this has $pace$'), r'"this has $pace$"');
    });

    test('quoteBatch case 7', () {
      expect(quoteBatch(r'this has %spaces%'), r'"this has ^%spaces^%"');
    });
  });

  group('errorCaseSplitBatch', () {
    test('splitBatch case error case 1', () {
      expect(
          splitBatch(
                  r'"\\vmware-host\Shared Folders\src\github.com\buildkite\agent\llamas @% test\buildkite-agent.exe" "start')
              .error,
          'Expected closing quote " at offset 102, got EOF');
    });

    test('splitBatch case error case 2', () {
      expect(splitBatch(r'simple --string ""quo""ted"').error,
          'Expected closing quote " at offset 26, got EOF');
    });

    test('splitBatch case error case 3', () {
      expect(splitBatch(r"echo ^^^^^&\'").error,
          "Expected closing quote ' at offset 12, got EOF");
    });
  });
}
