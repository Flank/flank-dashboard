// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

/// A class containing a result for Slack API interaction.
class SlackResult {
  /// Used to indicate that interaction is failed.
  final bool _isError;

  /// Contains message with a result of interaction.
  /// Contains error message if interaction failed.
  final String message;

  bool get isError => _isError;

  bool get isSuccess => !_isError;

  SlackResult._(this._isError, this.message);

  /// Creates an instance representing a failed interaction with Slack API.
  SlackResult.error([String message]) : this._(true, message);

  /// Creates an instance representing a successful interaction with Slack API.
  SlackResult.success([String message]) : this._(false, message);

  @override
  String toString() {
    return '$runtimeType {isError: $_isError, message: $message}';
  }
}
