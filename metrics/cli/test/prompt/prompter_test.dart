import 'package:cli/prompt/prompter.dart';
import 'package:cli/prompt/writer/prompt_writer.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  const promptText = 'promptText';
  final Matcher throwsAssertionError = throwsA(isA<AssertionError>());
  final writerMock = _MockPromptWriter();

  tearDown(() {
    reset(writerMock);
  });

  group("Prompter", () {
    test(
      ".initialize() throws an AssertionError if the given prompt writer is null",
      () {
        expect(() => Prompter.initialize(null), throwsAssertionError);
      },
    );

    test(
      ".prompt() throws an AssertionError if the prompter is not initialized",
      () {
        expect(() => Prompter.prompt('text'), throwsAssertionError);
      },
    );

    test(
      ".promptConfirm() throws an AssertionError if the prompter is not initialized",
      () {
        expect(() => Prompter.promptConfirm('text'), throwsAssertionError);
      },
    );

    test(
      ".promptTerminate() throws an AssertionError if the prompter is not initialized",
      () {
        expect(() => Prompter.promptTerminate(), throwsAssertionError);
      },
    );

    test(
      ".initialize() initializes the logger with the given prompt writer",
      () async {
        Prompter.initialize(writerMock);

        await Prompter.prompt(promptText);

        verify(writerMock.prompt(promptText)).called(1);
      },
    );

    test(
      ".prompt() requests an input from the user with the given description text",
      () async {
        await Prompter.prompt(promptText);

        verify(writerMock.prompt(promptText)).called(1);
      },
    );

    test(
      ".promptConfirm() requests a confirmation input from the user with the given description text",
      () async {
        await Prompter.promptConfirm(promptText);

        verify(writerMock.promptConfirm(promptText)).called(1);
      },
    );

    test(
      ".promptTerminate() terminates a prompt session for the current prompt writer",
      () async {
        await Prompter.promptTerminate();

        verify(writerMock.promptTerminate()).called(1);
      },
    );
  });
}

class _MockPromptWriter extends Mock implements PromptWriter {}
