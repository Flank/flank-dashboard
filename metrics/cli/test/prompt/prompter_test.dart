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
    final promptWriter = PromptWriterMock();
    final prompter = Prompter(promptWriter);

    tearDown(() {
      reset(promptWriter);
    });

    test(
      "throws an ArgumentError if the given prompt writer is null",
      () {
        expect(() => Prompter(null), throwsArgumentError);
      },
    );

    test(
      ".prompt() requests an input from the user with the given description text",
      () async {
        prompter.prompt(promptText);

        verify(promptWriter.prompt(promptText)).called(once);
      },
    );

    test(
      ".prompt() returns an input from the user",
      () async {
        const answer = 'userAnswer';

        when(promptWriter.prompt(promptText)).thenReturn(answer);
        final result = prompter.prompt(promptText);

        expect(result, equals(answer));
      },
    );

    test(
      ".promptConfirm() requests a confirmation input from the user with the given description text",
      () async {
        prompter.promptConfirm(promptText, confirmInput: confirmInput);

        verify(promptWriter.promptConfirm(promptText, confirmInput))
            .called(once);
      },
    );

    test(
      ".promptConfirm() returns a confirmation result",
      () async {
        const confirmInput = 'yes';

        when(promptWriter.promptConfirm(promptText, confirmInput))
            .thenReturn(true);

        final result = prompter.promptConfirm(
          promptText,
          confirmInput: confirmInput,
        );

        expect(result, isTrue);
      },
    );

    test(
      ".promptConfirm() applies a default confirm input if it's not specified",
      () {
        prompter.promptConfirm(promptText);

        verify(promptWriter.promptConfirm(promptText, argThat(isNotNull)))
            .called(once);
      },
    );
  });
}
