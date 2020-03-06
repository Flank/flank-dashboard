/// A class containing a result for Jenkins API interaction.
class JenkinsResult<T> {
  /// Used to indicate that interaction is failed.
  final bool _isError;

  /// Contains message with a result of interaction.
  /// Contains error message if interaction failed.
  final String message;

  /// Contains a result of interaction.
  ///
  /// Generally, the parsed body from response.
  final T result;

  bool get isError => _isError;

  bool get isSuccess => !_isError;

  JenkinsResult._(this._isError, this.message, this.result);

  /// Creates an instance representing a failed interaction with Jenkins API.
  JenkinsResult.error({
    String message,
    T result,
  }) : this._(true, message, result);

  /// Creates an instance representing a successful interaction with Jenkins API.
  JenkinsResult.success({
    String message,
    T result,
  }) : this._(false, message, result);

  @override
  String toString() {
    return '$runtimeType { isError: $_isError, '
        'message: $message, '
        'result: $result }';
  }
}
