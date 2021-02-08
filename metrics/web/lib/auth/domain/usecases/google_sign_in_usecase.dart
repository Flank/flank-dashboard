// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/auth/domain/repositories/user_repository.dart';
import 'package:metrics/auth/domain/entities/authentication_exception.dart';
import 'package:metrics/auth/domain/entities/auth_error_code.dart';
import 'package:metrics/base/domain/usecases/usecase.dart';

/// The use case that provides an ability to sign in a user
/// to the app using Google authentication.
class GoogleSignInUseCase implements UseCase<Future<void>, void> {
  final UserRepository _repository;

  /// Creates a [GoogleSignInUseCase] with the given [UserRepository].
  GoogleSignInUseCase(this._repository) : assert(_repository != null);

  @override
  Future<void> call([_]) async {
    final credentials = await _repository.getGoogleSignInCredentials();
    final email = credentials.email;
    final emailDomain = email.substring(email.indexOf('@') + 1);
    final validationResult = await _repository.validateEmailDomain(emailDomain);

    if (!validationResult.isValid) {
      await _repository.signOut();
      throw const AuthenticationException(
        code: AuthErrorCode.notAllowedEmailDomain,
      );
    }

    return _repository.signInWithGoogle(credentials);
  }
}
