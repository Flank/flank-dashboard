import 'package:cli/util/prompt_wrapper.dart';

/// A util class that provides methods for different prompts.
class PromptUtil {
  /// A [PromptWrapper] this util uses to prompt.
  static PromptWrapper _promptWrapper;

  /// Initializes this logger with the given [promptWrapper].
  ///
  /// Throws an [AssertionError] if the given [promptWrapper] is `null`.
  static void init(PromptWrapper promptWrapper) {
    assert(promptWrapper != null);

    _promptWrapper = promptWrapper;
  }

  /// Prompts a [text].
  ///
  /// Throws an [AssertionError] if the given [promptWrapper] is `null`.
  static Future<String> prompt(String text, {Stream<List<int>> stdin}) async {
    assert(_promptWrapper != null);

    return _promptWrapper.prompt(text, stdin: stdin);
  }

  /// Prompts with confirming.
  ///
  /// Throws an [AssertionError] if the given [promptWrapper] is `null`.
  static Future<bool> promptConfirm(
    String text, {
    Stream<List<int>> stdin,
  }) async {
    assert(_promptWrapper != null);

    return _promptWrapper.promptConfirm(text, stdin: stdin);
  }

  /// Terminate a prompt session.
  ///
  /// Throws an [AssertionError] if the given [promptWrapper] is `null`.
  static Future<void> promptTerminate() async {
    assert(_promptWrapper != null);

    return _promptWrapper.promptTerminate();
  }
}
