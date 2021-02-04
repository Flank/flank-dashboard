// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:meta/meta.dart';
import 'package:metrics/auth/domain/entities/auth_error_code.dart';

/// Represents the authentication exception.
@immutable
class AuthenticationException implements Exception {
  /// A unique code that identifies this exception.
  final AuthErrorCode code;

  /// A human-friendly message that describes this exception.
  final String message;

  /// Creates the [AuthenticationException] with the given [message] and [code].
  ///
  /// [code] is the code of this error that specifies the concrete reason for the exception occurrence.
  /// If nothing or null is passed - the [AuthErrorCode.unknown] will be used.
  /// [message] is the text description of this exception.
  const AuthenticationException({
    AuthErrorCode code,
    this.message,
  }) : code = code ?? AuthErrorCode.unknown;
}
