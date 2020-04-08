import 'package:metrics/features/auth/domain/entities/user.dart';
import 'package:metrics/features/auth/domain/repositories/user_repository.dart';
import 'package:mockito/mockito.dart';

/// Mock implementation of the [UserRepository].
///
/// Provides test implementation of the [UserRepository] methods.
class UserRepositoryMock extends Mock implements UserRepository {
  UserRepositoryMock() {
    when(authenticationStream()).thenAnswer((_) => const Stream<User>.empty());
    when(signInWithEmailAndPassword(any, any)).thenAnswer((_) async {});
    when(signOut()).thenAnswer((_) async {});
  }
}
