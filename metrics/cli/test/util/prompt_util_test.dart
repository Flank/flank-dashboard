import 'package:cli/util/prompt_util.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../test_util/called_once_verification_result.dart';
import '../test_util/prompt_wrapper_mock.dart';

void main() {
  group("PromptUtil", () {
    const testText = 'testText';
    final promptWrapperMock = PromptWrapperMock();

    setUp(() {
      reset(promptWrapperMock);
    });

    test(
      ".initialize() throws an AssertionError if the given writer is null",
      () {
        expect(() => PromptUtil.init(null), throwsA(isA<AssertionError>()));
      },
    );

    test(".prompt() throws an AssertionError if the given writer is null", () {
      expect(
        () => PromptUtil.prompt(testText),
        throwsA(isA<AssertionError>()),
      );
    });

    test(
      ".promptConfirm() throws an AssertionError if the given writer is null",
      () {
        expect(
          () => PromptUtil.promptConfirm(testText),
          throwsA(isA<AssertionError>()),
        );
      },
    );

    test(
      ".promptTerminate() throws an AssertionError if the given writer is null",
      () {
        expect(
          () => PromptUtil.promptTerminate(),
          throwsA(isA<AssertionError>()),
        );
      },
    );

    test(".init() initializes the promptWrapper with the given one", () async {
      PromptUtil.init(promptWrapperMock);

      final future = PromptUtil.prompt(testText);

      expect(future, completes);
      verify(promptWrapperMock.prompt(testText)).calledOnce();
    });

    test(".prompt() creates a simple prompt", () async {
      PromptUtil.init(promptWrapperMock);
      await PromptUtil.prompt(testText);

      verify(promptWrapperMock.prompt(testText)).calledOnce();
    });

    test(".promptConfirm() creates prompt with a confirmation", () async {
      PromptUtil.init(promptWrapperMock);
      await PromptUtil.promptConfirm(testText);

      verify(promptWrapperMock.promptConfirm(testText)).calledOnce();
    });

    test(".promptTerminate() terminate a prompt session", () async {
      PromptUtil.init(promptWrapperMock);
      await PromptUtil.promptTerminate();

      verify(promptWrapperMock.promptTerminate()).calledOnce();
    });
  });
}
