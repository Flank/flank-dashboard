// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:cli/helper/file_helper.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../test_utils/matchers.dart';

void main() {
  group("FileHelper", () {
    const key1 = '\$key1';
    const key2 = '\$key2';
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

    PostExpectation<Future<bool>> whenFileExists() {
      return when(file.exists());
    }

    test(
      ".replaceEnvironmentVariables() does not read the content if the given environment is null",
      () async {
        whenFileExists().thenAnswer((_) => Future.value(true));

        await helper.replaceEnvironmentVariables(file, null);

        verifyNever(file.writeAsString(any));
      },
    );

    test(
      ".replaceEnvironmentVariables() does not read the content if the given environment is empty",
      () async {
        whenFileExists().thenAnswer((_) => Future.value(true));

        await helper.replaceEnvironmentVariables(file, {});

        verifyNever(file.writeAsString(any));
      },
    );

    test(
      ".replaceEnvironmentVariables() does not read the content if the given file is null",
      () async {
        await helper.replaceEnvironmentVariables(null, environment);

        verifyNever(file.writeAsString(any));
      },
    );

    test(
      ".replaceEnvironmentVariables() does not read the content if the given file does not exist",
      () async {
        whenFileExists().thenAnswer((_) => Future.value(false));

        await helper.replaceEnvironmentVariables(file, environment);

        verifyNever(file.writeAsString(any));
      },
    );

    test(
      ".replaceEnvironmentVariables() updates the content according to the given environment",
      () async {
        const content = 'test=$key1; someField=$key2;';
        const expected = 'test=$value1; someField=$value2;';

        whenFileExists().thenAnswer((_) => Future.value(true));
        when(file.readAsString()).thenAnswer((_) => Future.value(content));

        await helper.replaceEnvironmentVariables(file, environment);

        verify(file.writeAsString(expected)).called(once);
      },
    );

    test(
      ".deleteDirectory() does not delete the given directory if it is null",
      () async {
        await helper.deleteDirectory(null);

        verifyNever(directory.delete());
      },
    );

    test(
      ".deleteDirectory() does not delete the given directory if it is not exists",
      () async {
        when(directory.exists()).thenAnswer((_) => Future.value(false));

        await helper.deleteDirectory(directory);

        verifyNever(directory.delete());
      },
    );

    test(
      ".deleteDirectory() deletes the given directory",
      () async {
        when(directory.exists()).thenAnswer((_) => Future.value(true));

        await helper.deleteDirectory(directory);

        verify(directory.delete()).called(once);
      },
    );
  });
}

class _FileMock extends Mock implements File {}

class _DirectoryMock extends Mock implements Directory {}
