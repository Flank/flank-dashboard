// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/auth/domain/repositories/user_repository.dart';
import 'package:metrics/auth/domain/usecases/parameters/user_profile_param.dart';
import 'package:metrics/base/domain/usecases/usecase.dart';

/// A [UseCase] that provides an ability to create a new user profile.
class CreateUserProfileUseCase
    implements UseCase<Future<void>, UserProfileParam> {
  /// A [UserRepository] that provides an ability to interact
  /// with the persistent store.
  final UserRepository _repository;

  /// Creates a new instance of the [CreateUserProfileUseCase].
  ///
  /// The given [UserRepository] must not be `null`.
  CreateUserProfileUseCase(this._repository) {
    ArgumentError.checkNotNull(_repository, '_repository');
  }

  @override
  Future<void> call(UserProfileParam params) {
    return _repository.createUserProfile(
      params.id,
      params.selectedTheme,
    );
  }
}
