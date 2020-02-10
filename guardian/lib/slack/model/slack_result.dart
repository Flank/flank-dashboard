class SlackResult {
  final bool isError;
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
