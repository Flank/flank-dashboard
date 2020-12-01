import 'package:meta/meta.dart';

/// A class that represents a CI integrations synchronization [Error].
@immutable
class SyncError extends Error {
  /// A [String] description of this error.
  final String message;

  /// Creates a new instance of the [SyncError].
  SyncError({this.message});

  @override
  String toString() {
    return message ?? '';
  }
}
