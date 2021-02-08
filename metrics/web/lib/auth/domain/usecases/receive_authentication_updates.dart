// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/auth/domain/entities/user.dart';
import 'package:metrics/auth/domain/repositories/user_repository.dart';
import 'package:metrics/base/domain/usecases/usecase.dart';

/// The use case that provides an ability to receive authentication updates.
class ReceiveAuthenticationUpdates implements UseCase<Stream<User>, void> {
  final UserRepository _repository;

  /// Creates a [ReceiveAuthenticationUpdates] with the given [UserRepository].
  ReceiveAuthenticationUpdates(this._repository) : assert(_repository != null);

  @override
  Stream<User> call([_]) {
    return _repository.authenticationStream();
  }
}
