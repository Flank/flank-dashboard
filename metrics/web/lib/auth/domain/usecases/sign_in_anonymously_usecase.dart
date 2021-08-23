// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/auth/domain/repositories/user_repository.dart';
import 'package:metrics/base/domain/usecases/usecase.dart';

/// The use case that provides an ability to sign in user anonymously.
class SignInAnonymouslyUseCase implements UseCase<void, void> {
  final UserRepository _repository;

  /// Creates a [SignInAnonymouslyUseCase] with the given [UserRepository].
  SignInAnonymouslyUseCase(this._repository) : assert(_repository != null);

  @override
  Future<void> call([_]) async {
    return _repository.signInAnonymously();
  }
}
