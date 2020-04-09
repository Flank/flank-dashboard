import 'package:metrics/features/auth/presentation/state/user_store.dart';

class UserStoreStub implements UserStore {
  const UserStoreStub();

  @override
  Stream get loggedInStream => null;

  @override
  bool get isLoggedIn => false;

  @override
  String get authErrorMessage => '';

  @override
  void subscribeToAuthenticationUpdates() {}

  @override
  void signInWithEmailAndPassword(String email, String password) {}

  @override
  void signOut() {}

  @override
  void dispose() {}
}