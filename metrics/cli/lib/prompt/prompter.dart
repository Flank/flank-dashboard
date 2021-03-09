import 'package:cli/prompt/writer/prompt_writer.dart';

/// A class that provides methods for working with prompts
/// using a [PromptWriter].
///
/// Before calling any methods, this should be initialized with the
/// [PromptWriter] using the [Prompter.initialize] method.
class Prompter {
  /// A [PromptWriter] this prompter uses to work with prompts.
  static PromptWriter _promptWriter;

  /// Initializes this prompter with the given [promptWriter].
  ///
  /// Throws an [AssertionError] if the given [promptWriter] is `null`.
  static void initialize(PromptWriter promptWriter) {
    assert(promptWriter != null);
    _promptWriter = promptWriter;
  }

  /// Requests an input from the user with a given description [text].
  ///
  /// Throws an [AssertionError] if the current
  /// [PromptWriter] instance is `null`.
  static Future<String> prompt(String text) {
    assert(_promptWriter != null);

    return _promptWriter.prompt(text);
  }

  /// Requests a confirmation input from the user
  /// with a given description [text].
  ///
  /// Throws an [AssertionError] if the current
  /// [PromptWriter] instance is `null`.
  static Future<bool> promptConfirm(String text) {
    assert(_promptWriter != null);

    return _promptWriter.promptConfirm(text);
  }

  /// Terminates a prompt session.
  ///
  /// Throws an [AssertionError] if the current
  /// [PromptWriter] instance is `null`.
  static Future<void> promptTerminate() {
    assert(_promptWriter != null);

    return _promptWriter.promptTerminate();
  }
}
