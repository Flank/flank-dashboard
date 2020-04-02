import 'package:meta/meta.dart';
import 'package:metrics/features/auth/domain/entities/auth_error_code.dart';

/// Represents the authentication exception.
@immutable
class AuthenticationException implements Exception {
  final AuthErrorCode code;
  final String message;

  /// Creates the [AuthenticationException] with the given [message] and [code].
  ///
  /// Throws an [ArgumentError] if [code] is null.
  ///
  /// [code] is the code of this error that specifies the concrete reason for the exception occurrence.
  /// [message] is the text description of this exception.
  const AuthenticationException({
    @required AuthErrorCode code,
    this.message,
  }) : code = code ?? AuthErrorCode.unknown;
}
