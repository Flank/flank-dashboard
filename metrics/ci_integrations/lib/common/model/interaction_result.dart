/// A class containing a result of an interaction.
class InteractionResult<T> {
  /// Used to indicate that interaction is failed.
  final bool _isError;

  /// Contains message with a result of interaction.
  final String message;

  /// Contains a result of interaction.
  ///
  /// Generally, the parsed body from response.
  final T result;

  /// Indicates if the interaction has finished with an error.
  bool get isError => _isError;

  /// Indicates if the interaction has finished successfully.
  bool get isSuccess => !_isError;

  const InteractionResult._(this._isError, this.message, this.result);

  /// Creates an instance representing a failed interaction with Jenkins API.
  const InteractionResult.error({String message, T result})
      : this._(true, message, result);

  /// Creates an instance representing a successful interaction with Jenkins API.
  const InteractionResult.success({String message, T result})
      : this._(false, message, result);

  @override
  String toString() {
    return '$runtimeType { isError: $_isError, '
        'message: $message, '
        'result: $result }';
  }
}
