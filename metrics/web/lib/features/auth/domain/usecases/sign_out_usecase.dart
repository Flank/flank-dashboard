import 'package:metrics/core/usecases/usecase.dart';
import 'package:metrics/features/auth/domain/repositories/user_repository.dart';

/// User case that provides an ability to sign out user.
class SignOutUseCase implements UseCase<Future<void>, void> {
  final UserRepository _repository;

  /// Creates a [SignOutUseCase] with the given [UserRepository].
  SignOutUseCase(this._repository) : assert(_repository != null);

  @override
  Future<void> call([_]) {
    return _repository.signOut();
  }
}
