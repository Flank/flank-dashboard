// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/prompt/prompter.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../test_utils/matchers.dart';
import '../test_utils/prompt_writer_mock.dart';

void main() {
  group("Prompter", () {
    const promptText = 'promptText';
    const confirmInput = 'yes';
    final writerMock = PromptWriterMock();
    final prompter = Prompter(writerMock);

    tearDown(() {
      reset(writerMock);
    });

    test(
      "throws an AssertionError if the given prompt writer is null",
      () {
        expect(() => Prompter(null), throwsAssertionError);
      },
    );

    test(
      ".prompt() requests an input from the user with the given description text",
      () async {
        prompter.prompt(promptText);

        verify(writerMock.prompt(promptText)).called(once);
      },
    );

    test(
      ".promptConfirm() requests a confirmation input from the user with the given description text",
      () async {
        prompter.promptConfirm(promptText, confirmInput: confirmInput);

        verify(writerMock.promptConfirm(promptText, confirmInput)).called(once);
      },
    );

    test(
      ".promptConfirm() applies a default confirm input if it's not specified",
      () {
        prompter.promptConfirm(promptText);

        verify(writerMock.promptConfirm(promptText, argThat(isNotNull)))
            .called(once);
      },
    );
  });
}
