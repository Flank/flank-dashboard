import 'package:meta/meta.dart';

/// [ValidationException] object thrown in the case of a validation error.
@immutable
class ValidationException extends Error {
  final String message;

  ValidationException(this.message) : assert(message != null);
}
