// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/prompt/writer/prompt_writer.dart';

/// A class that provides methods for working with prompts
/// using a [PromptWriter].
///
/// Before calling any methods, this should be initialized with the
/// [PromptWriter] using the [Prompter.initialize] method.
class Prompter {
  /// A [PromptWriter] this prompter uses to write prompts.
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
  static Future<String> prompt(String text) async {
    assert(_promptWriter != null);

    return _promptWriter.prompt(text);
  }

  /// Requests a [confirmInput] from the user
  /// with a given description [text].
  ///
  /// Throws an [AssertionError] if the current
  /// [PromptWriter] instance is `null`.
  static Future<bool> promptConfirm(String text, String confirmInput) async {
    assert(_promptWriter != null);

    return _promptWriter.promptConfirm(text, confirmInput);
  }

  /// Disposes this [PromptWriter]'s resources.
  ///
  /// Throws an [AssertionError] if the current
  /// [PromptWriter] instance is `null`.
  static Future<void> dispose() async {
    assert(_promptWriter != null);

    return _promptWriter.dispose();
  }
}
