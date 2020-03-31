import 'package:metrics/features/auth/domain/entities/user.dart';
import 'package:metrics/features/auth/domain/repositories/user_repository.dart';
import 'package:metrics/features/auth/service/exceptions/sign_in_exception.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<User> currentUser() async {
    return null;
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    if (password == 'qqq') {
      return dummyUser();
    } else {
      throw SignInException(
        title: 'Sign in with email and password',
        code: 'auth/invalid-password',
        message: 'Email or password is invalid',
      );
    }
  }

  @override
  Future<void> signOut() async {
    return;
  }

  User dummyUser() {
    return const User(uid: 'SOMEUID', email: 'test@test.com');
  }
}
