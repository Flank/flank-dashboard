// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

/// An abstract class for prompt writers that provide methods
/// for working with prompts.
abstract class PromptWriter {
  /// Requests an input from the user with a given description [text].
  String prompt(String text);

  /// Requests a [confirmInput] from the user
  /// with a given description [text].
  bool promptConfirm(String text, String confirmInput);
}
