import 'package:metrics/auth/domain/repositories/user_repository.dart';
import 'package:metrics/base/domain/usecases/usecase.dart';

/// The use case that provides an ability to sign in user anonymously.
class SignInAnonymouslyUseCase implements UseCase {
  final UserRepository _repository;

  /// Creates a [SignInAnonymouslyUseCase] with the given [UserRepository].
  SignInAnonymouslyUseCase(this._repository);

  @override
  Future<void> call(_) async {
    return _repository.signInAnonymously();
  }
}