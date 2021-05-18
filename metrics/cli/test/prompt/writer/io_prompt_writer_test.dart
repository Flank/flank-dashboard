// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:cli/prompt/writer/io_prompt_writer.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../test_utils/matchers.dart';

void main() {
  group("IOPromptWriter", () {
    const promptText = 'text';
    const confirmText = 'confirm';
    final stdinMock = _StdinMock();
    final stdoutMock = _StdoutMock();

    final writer = IOPromptWriter(
      inputStream: stdinMock,
      outputStream: stdoutMock,
    );

    tearDown(() {
      reset(stdinMock);
      reset(stdoutMock);
    });

    test(
      ".info() displays the given text",
      () {
        writer.info(promptText);

        verify(stdoutMock.writeln(promptText)).called(once);
      },
    );

    test(
      ".prompt() requests an input from the user with the given description text",
      () {
        writer.prompt(promptText);

        verifyInOrder([
          stdoutMock.writeln(promptText),
          stdinMock.readLineSync(),
        ]);
      },
    );

    test(
      ".promptConfirm() requests a confirm input from the user with a given description text",
      () {
        writer.promptConfirm(promptText, confirmText);

        verifyInOrder([
          stdoutMock.writeln(promptText),
          stdinMock.readLineSync(),
        ]);
      },
    );

    test(
      ".promptConfirm() returns true if the input from the user equals to the confirmation text",
      () {
        when(stdinMock.readLineSync()).thenReturn(confirmText);

        final actual = writer.promptConfirm(promptText, confirmText);

        expect(actual, isTrue);
      },
    );

    test(
      ".promptConfirm() returns false if the input from the user does not equal to the confirmation text",
      () {
        when(stdinMock.readLineSync()).thenReturn('no');

        final actual = writer.promptConfirm(promptText, confirmText);

        expect(actual, isFalse);
      },
    );
  });
}

class _StdinMock extends Mock implements Stdin {}

class _StdoutMock extends Mock implements Stdout {}
