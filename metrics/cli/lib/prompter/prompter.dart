// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/prompter/writer/prompt_writer.dart';

/// A class that provides methods for working with prompts
/// using a [PromptWriter].
class Prompter {
  /// A [PromptWriter] this prompter uses to write prompts.
  final PromptWriter _promptWriter;

  /// Creates a new instance of the [Prompter] with the given [PromptWriter].
  ///
  /// Throws an [AssertionError] if the given [PromptWriter] is `null`.
  Prompter(this._promptWriter) {
    ArgumentError.checkNotNull(_promptWriter, 'promptWriter');
  }

  /// Displays the given [text] to the user.
  void info(String text) {
    _promptWriter.info(text);
  }

  /// Requests an input from the user with a given description [text].
  String prompt(String text) {
    return _promptWriter.prompt(text);
  }

  /// Requests a [confirmInput] from the user with a given description [text].
  ///
  /// The [confirmInput] default value is `y`.
  bool promptConfirm(
    String text, {
    String confirmInput = 'y',
  }) {
    return _promptWriter.promptConfirm(text, confirmInput);
  }
}
