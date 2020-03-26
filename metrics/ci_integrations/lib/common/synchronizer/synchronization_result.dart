import 'package:meta/meta.dart';

/// A class containing the result of synchronization process.
@immutable
class SynchronizationResult {
  /// Used to indicate that synchronization is failed.
  final bool _isError;

  /// Contains a message with a result of synchronization.
  final String message;

  /// Indicates if the synchronization has finished with an error.
  bool get isFailed => _isError;

  /// Indicates if the synchronization has finished successfully.
  bool get isSuccess => !_isError;

  const SynchronizationResult._(this._isError, this.message);

  /// Creates an instance representing a result of a failed synchronization
  /// process.
  const SynchronizationResult.error({String message}) : this._(true, message);

  /// Creates an instance representing a result of a successful synchronization
  /// process.
  const SynchronizationResult.success({String message})
      : this._(false, message);
}
