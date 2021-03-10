// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

/// An abstract class for prompt writers that provide methods
/// for working with prompts.
abstract class PromptWriter {
  /// Requests an input from the user with a given description [text].
  Future<String> prompt(String text);

  /// Requests a confirmation input from the user
  /// with a given description [text].
  Future<bool> promptConfirm(String text);

  /// Terminates a prompt session.
  Future<void> promptTerminate();
}
