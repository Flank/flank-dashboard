import 'package:metrics/features/auth/domain/entities/user.dart';

abstract class IUserRepository {
  Future<User> currentUser();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<void> signOut();
}
