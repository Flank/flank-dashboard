/// A class containing result for Slack API interaction.
class SlackResult {
  /// Used to indicate that interaction failed.
  final bool isError;

  /// Contains message with a result of interaction.
  /// Contains error if interaction failed.
  final String message;

  SlackResult({
    this.isError,
    this.message,
  });

  SlackResult.error([
    String message,
  ]) : this(
          isError: true,
          message: message,
        );

  SlackResult.success([
    String message,
  ]) : this(
          isError: false,
          message: message,
        );

  @override
  String toString() {
    return '$runtimeType {isError: $isError, message: $message}';
  }
}
