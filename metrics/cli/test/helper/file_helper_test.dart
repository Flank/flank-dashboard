// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:cli/helper/file_helper.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../test_utils/matchers.dart';

void main() {
  group("FileHelper", () {
    const key1 = 'key1';
    const key2 = 'key2';
    const value1 = 'value1';
    const value2 = 'value2';
    const environment = <String, dynamic>{
      key1: value1,
      key2: value2,
    };

    final file = _FileMock();
    final directory = _DirectoryMock();
    final helper = FileHelper();

    tearDown(() {
      reset(file);
      reset(directory);
    });

    PostExpectation<bool> whenFileExists() {
      return when(file.existsSync());
    }

    test(
      ".getFile() returns the file with the given path",
      () {
        const path = 'testPath';

        final file = helper.getFile(path);

        expect(file.path, path);
      },
    );

    test(
      ".getDirectory() returns the directory with the given path",
      () {
        const path = 'testPath';

        final directory = helper.getDirectory(path);

        expect(directory.path, path);
      },
    );

    test(
      ".replaceEnvironmentVariables() throws an ArgumentError if the given file is null",
          () {
        expect(
              () => helper.replaceEnvironmentVariables(null, environment),
          throwsArgumentError,
        );
      },
    );

    test(
      ".replaceEnvironmentVariables() throws an ArgumentError if the given environment is null",
      () {
        expect(
          () => helper.replaceEnvironmentVariables(file, null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".replaceEnvironmentVariables() does not read the content if the given environment is empty",
      () {
        whenFileExists().thenReturn(true);

        helper.replaceEnvironmentVariables(file, {});

        verifyNever(file.writeAsStringSync(any));
      },
    );

    test(
      ".replaceEnvironmentVariables() does not read the content if the given file is empty",
      () async {
        whenFileExists().thenReturn(false);

        helper.replaceEnvironmentVariables(file, environment);

        verifyNever(file.writeAsStringSync(any));
      },
    );

    test(
      ".replaceEnvironmentVariables() updates the content according to the given environment",
      () async {
        const content = 'test=\$$key1; someField=\$$key2;';
        const expected = 'test=$value1; someField=$value2;';

        whenFileExists().thenReturn(true);
        when(file.readAsStringSync()).thenReturn(content);

        helper.replaceEnvironmentVariables(file, environment);

        verify(file.writeAsStringSync(expected)).called(once);
      },
    );
  });
}

class _FileMock extends Mock implements File {}

class _DirectoryMock extends Mock implements Directory {}
