// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/auth/domain/repositories/user_repository.dart';
import 'package:metrics/auth/domain/usecases/parameters/user_profile_param.dart';
import 'package:metrics/base/domain/usecases/usecase.dart';

/// A [UseCase] that provides an ability to update the user profile.
class UpdateUserProfileUseCase
    implements UseCase<Future<void>, UserProfileParam> {
  /// A [UserRepository] that provides an ability to interact
  /// with the persistent store.
  final UserRepository _repository;

  /// Creates a new instance of the [UpdateUserProfileUseCase].
  ///
  /// The given [UserRepository] must not be `null`.
  UpdateUserProfileUseCase(this._repository) {
    ArgumentError.checkNotNull(_repository, '_repository');
  }

  @override
  Future<void> call(UserProfileParam params) {
    return _repository.updateUserProfile(
      params.id,
      params.selectedTheme,
    );
  }
}
