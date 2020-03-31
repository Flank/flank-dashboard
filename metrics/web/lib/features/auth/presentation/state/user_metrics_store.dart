import 'package:metrics/features/auth/data/repositories/user_repository_impl.dart';
import 'package:metrics/features/auth/domain/entities/user.dart';

class UserMetricsStore {
  final UserRepositoryImpl userRepositoryImpl;
  User user;

  UserMetricsStore({this.userRepositoryImpl});

  Future<void> currentUser() async {
    user = await userRepositoryImpl.currentUser();
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    user = await userRepositoryImpl.signInWithEmailAndPassword(email, password);
  }

  Future<void> signOut() async {
    await userRepositoryImpl.signOut();
    user = null;
  }
}
