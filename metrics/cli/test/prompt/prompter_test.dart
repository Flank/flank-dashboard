// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/prompt/prompter.dart';
import 'package:cli/prompt/writer/prompt_writer.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../test_utils/matchers.dart';

void main() {
  group("Prompter", () {
    const promptText = 'promptText';
    const confirmInput = 'yes';
    final writerMock = _PromptWriterMock();

    tearDown(() {
      reset(writerMock);
    });

    test(
      ".initialize() throws an AssertionError if the given prompt writer is null",
      () {
        expect(() => Prompter.initialize(null), throwsAssertionError);
      },
    );

    test(
      ".initialize() initializes the logger with the given prompt writer",
      () async {
        Prompter.initialize(writerMock);

        Prompter.prompt(promptText);

        verify(writerMock.prompt(promptText)).called(once);
      },
    );

    test(
      ".prompt() requests an input from the user with the given description text",
      () async {
        Prompter.prompt(promptText);

        verify(writerMock.prompt(promptText)).called(once);
      },
    );

    test(
      ".promptConfirm() requests a confirmation input from the user with the given description text",
      () async {
        Prompter.promptConfirm(promptText, confirmInput: confirmInput);

        verify(writerMock.promptConfirm(promptText, confirmInput))
            .called(once);
      },
    );

    test(
      ".promptConfirm() applies a default confirm input if it's not specified",
      () {
        Prompter.promptConfirm(promptText);

        verify(writerMock.promptConfirm(promptText, argThat(isNotNull)))
            .called(once);
      },
    );
  });
}

class _PromptWriterMock extends Mock implements PromptWriter {}
