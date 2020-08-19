import 'package:metrics/auth/domain/repositories/user_repository.dart';
import 'package:metrics/base/domain/usecases/usecase.dart';

/// The use case that provides an ability to sign in a user with Google.
class GoogleSignInUseCase implements UseCase<Future<void>, void> {
  final UserRepository _repository;

  /// Creates a [GoogleSignInUseCase] with the given [UserRepository].
  GoogleSignInUseCase(this._repository) : assert(_repository != null);

  @override
  Future<void> call([_]) {
    return _repository.signInWithGoogle();
  }
}
