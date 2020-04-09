import 'package:metrics/features/auth/presentation/state/user_store.dart';
import 'package:rxdart/rxdart.dart';

/// Stub of [UserStore] ensures that a user is already logged in into the app.
class LoggedInUserStoreStub extends UserStore {
  LoggedInUserStoreStub();

  final BehaviorSubject<bool> _isLoggedInSubject = BehaviorSubject();

  @override
  Stream get loggedInStream => _isLoggedInSubject.stream;

  @override
  bool get isLoggedIn => _isLoggedInSubject.value;

  @override
  void subscribeToAuthenticationUpdates() {
    _isLoggedInSubject.add(true);
  }

  @override
  void signOut() {
    _isLoggedInSubject.add(false);
  }
}