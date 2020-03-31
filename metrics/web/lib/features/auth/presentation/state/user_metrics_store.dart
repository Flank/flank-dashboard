import 'package:metrics/features/auth/data/repositories/user_repository_impl.dart';
import 'package:metrics/features/auth/domain/entities/user.dart';

class UserMetricsStore {
  final UserRepositoryImpl userRepository;
  User user;

  UserMetricsStore({this.userRepository});

  Future<void> currentUser() async {
    user = await userRepository.currentUser();
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    user = await userRepository.signInWithEmailAndPassword(email, password);
  }

  Future<void> signOut() async {
    await userRepository.signOut();
    user = null;
  }
}
