import 'package:metrics/features/auth/domain/entities/authentication_exception.dart';
import 'package:metrics/features/auth/domain/repositories/user_repository.dart';
import 'package:mockito/mockito.dart';

/// Mock implementation of the [UserRepository] that throws
/// an [AuthenticationException] from all methods.
class ErrorUserRepositoryMock extends Mock implements UserRepository {
  static const authException = AuthenticationException();

  ErrorUserRepositoryMock() {
    when(authenticationStream()).thenThrow(authException);
    when(signInWithEmailAndPassword(any, any)).thenThrow(authException);
    when(signOut()).thenThrow(authException);
  }
}
