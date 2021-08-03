// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/auth/domain/repositories/user_repository.dart';
import 'package:metrics/base/domain/usecases/usecase.dart';

/// A [UseCase] that provides an ability to receive the user profile updates.
class SignInAnonymouslyUseCase implements UseCase<void, void> {
  /// A [UserRepository] that provides an ability to interact
  /// with the persistent store.
  final UserRepository _repository;

  /// Creates a new instance of the [SignInAnonymouslyUseCase].
  ///
  /// The given [UserRepository] must not be `null`.
  SignInAnonymouslyUseCase(this._repository) {
    ArgumentError.checkNotNull(_repository, '_repository');
  }

  @override
  Future<void> call([_]) {
    return _repository.signInAnonymously();
  }
}
