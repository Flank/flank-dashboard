import 'package:metrics/core/usecases/usecase.dart';
import 'package:metrics/features/auth/domain/entities/user.dart';
import 'package:metrics/features/auth/domain/repositories/user_repository.dart';

/// The use case that provides an ability to receive current [User] updates.
class ReceiveCurrentUserUpdates implements UseCase<Stream<User>, void> {
  final UserRepository _repository;

  /// Creates a [ReceiveCurrentUserUpdates] with the given [UserRepository].
  ReceiveCurrentUserUpdates(this._repository) : assert(_repository != null);

  @override
  Stream<User> call([_]) {
    return _repository.currentUserStream();
  }
}
