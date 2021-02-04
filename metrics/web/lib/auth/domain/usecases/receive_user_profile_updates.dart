// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/auth/domain/entities/user_profile.dart';
import 'package:metrics/auth/domain/repositories/user_repository.dart';
import 'package:metrics/base/domain/usecases/usecase.dart';
import 'package:metrics/common/domain/usecases/parameters/user_id_param.dart';

/// A [UseCase] that provides an ability to receive the user profile updates.
class ReceiveUserProfileUpdates
    implements UseCase<Stream<UserProfile>, UserIdParam> {
  /// A [UserRepository] that provides an ability to interact
  /// with the persistent store.
  final UserRepository _repository;

  /// Creates a new instance of the [ReceiveUserProfileUpdates].
  ///
  /// The given [UserRepository] must not be `null`.
  ReceiveUserProfileUpdates(this._repository) {
    ArgumentError.checkNotNull(_repository, '_repository');
  }

  @override
  Stream<UserProfile> call(UserIdParam params) {
    return _repository.userProfileStream(params.id);
  }
}
