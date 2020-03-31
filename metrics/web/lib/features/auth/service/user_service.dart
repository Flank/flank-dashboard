import 'package:metrics/features/auth/domain/entities/user.dart';
import 'package:metrics/features/auth/service/interfaces/i_user_repository.dart';

/// Interact
class UserService {
  final IUserRepository userRepository;
  User user;

  UserService({this.userRepository});

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
