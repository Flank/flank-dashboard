import 'package:metrics/features/auth/domain/entities/user.dart';
import 'package:metrics/features/auth/domain/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';

class UserRepositoryStub implements UserRepository {
  final BehaviorSubject<User> _userUpdatesStream = BehaviorSubject();

  UserRepositoryStub({User seedUser}) {
    _userUpdatesStream.add(seedUser);
  }

  @override
  Stream<User> currentUserStream() {
    return _userUpdatesStream.stream;
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    _userUpdatesStream.add(User(id: 'id', email: email));
  }

  @override
  Future<void> signOut() async {
    _userUpdatesStream.add(null);
  }
}
