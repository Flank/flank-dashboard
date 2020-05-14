import 'package:metrics/auth/domain/repositories/user_repository.dart';
import 'package:metrics/auth/domain/usecases/parameters/user_credentials_param.dart';
import 'package:metrics/common/domain/usecases/usecase.dart';

/// The use case that provides an ability to sign in user.
class SignInUseCase implements UseCase<void, UserCredentialsParam> {
  final UserRepository _repository;

  /// Creates a [SignInUseCase] with the given [UserRepository].
  const SignInUseCase(this._repository) : assert(_repository != null);

  @override
  Future<void> call(UserCredentialsParam params) {
    return _repository.signInWithEmailAndPassword(
      params.email.value,
      params.password.value,
    );
  }
}
