import 'package:process_run/shell_run.dart' as cmd;

/// A prompt wrapper that helps to work with prompts.
class PromptWrapper {
  /// Prompts a [text].
  Future<String> prompt(String text, {Stream<List<int>> stdin}) async {
    return cmd.prompt(text, stdin: stdin);
  }

  /// Prompts with confirming.
  Future<bool> promptConfirm(String text, {Stream<List<int>> stdin}) async {
    return cmd.promptConfirm(text, stdin: stdin);
  }

  /// Terminates a prompt session.
  Future<void> promptTerminate() async {
    return cmd.promptTerminate();
  }
}
