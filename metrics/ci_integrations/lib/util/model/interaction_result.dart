// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

/// A class containing a result of an interaction.
class InteractionResult<T> {
  /// Used to indicate that this interaction is failed.
  final bool _isError;

  /// Contains a message with a result of this interaction.
  final String message;

  /// Contains a result of this interaction.
  ///
  /// Generally, the parsed body from the response.
  final T result;

  /// Indicates if this interaction has finished with an error.
  bool get isError => _isError;

  /// Indicates if this interaction has finished successfully.
  bool get isSuccess => !_isError;

  const InteractionResult._(this._isError, this.message, this.result);

  /// Creates an instance representing a failed interaction.
  const InteractionResult.error({String message, T result})
      : this._(true, message, result);

  /// Creates an instance representing a successful interaction.
  const InteractionResult.success({String message, T result})
      : this._(false, message, result);

  @override
  String toString() {
    return 'InteractionResult<$T> { isError: $_isError, '
        'message: $message, '
        'result: $result }';
  }
}
