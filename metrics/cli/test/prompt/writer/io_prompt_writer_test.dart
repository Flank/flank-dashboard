// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:cli/prompt/writer/io_prompt_writer.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  group("IOPromptWriter", () {
    const promptText = 'text';
    const confirmText = 'confirm';
    final stdinMock = _StdinMock();
    final stdoutMock = _StdoutMock();

    tearDown(() {
      reset(stdinMock);
      reset(stdoutMock);
    });

    test(
      ".prompt() requests an input from the user with the given description text",
      () {
        final writer = IOPromptWriter(
          inputStream: stdinMock,
          outputStream: stdoutMock,
        );

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
        final writer = IOPromptWriter(
          inputStream: stdinMock,
          outputStream: stdoutMock,
        );

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
        final writer = IOPromptWriter(
          inputStream: stdinMock,
          outputStream: stdoutMock,
        );

        when(stdinMock.readLineSync()).thenReturn(confirmText);

        final actual = writer.promptConfirm(promptText, confirmText);

        expect(actual, isTrue);
      },
    );

    test(
      ".promptConfirm() returns false if the input from the user does not equal to the confirmation text",
      () {
        final writer = IOPromptWriter(
          inputStream: stdinMock,
          outputStream: stdoutMock,
        );

        when(stdinMock.readLineSync()).thenReturn('no');

        final actual = writer.promptConfirm(promptText, confirmText);

        expect(actual, isFalse);
      },
    );

    test(".disposes() disposes resources", () async {
      final writer = IOPromptWriter(
        inputStream: stdinMock,
        outputStream: stdoutMock,
      );

      await writer.dispose();

      verifyInOrder([
        stdoutMock.flush(),
        stdoutMock.close(),
      ]);
    });
  });
}

class _StdinMock extends Mock implements Stdin {}

class _StdoutMock extends Mock implements Stdout {}
