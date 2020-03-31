import 'package:metrics/features/auth/domain/entities/user.dart';
import 'package:metrics/features/auth/service/exceptions/sign_in_exception.dart';
import 'package:metrics/features/auth/service/interfaces/i_user_repository.dart';

class UserRepository implements IUserRepository {
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
    return Future(() => null);
  }

  User dummyUser() {
    return const User(uid: 'SOMEUID', email: 'test@test.com');
  }
}
