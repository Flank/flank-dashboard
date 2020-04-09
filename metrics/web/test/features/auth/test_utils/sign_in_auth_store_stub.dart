import 'package:metrics/features/auth/presentation/state/auth_store.dart';
import 'package:rxdart/rxdart.dart';

/// Stub of [AuthStore] ensures that a user is already logged in into the app.
class SignInAuthStoreStub implements AuthStore {
  final BehaviorSubject<bool> _isLoggedInSubject = BehaviorSubject();
  String _authExceptionDescription;

  @override
  Stream<bool> get loggedInStream => _isLoggedInSubject.stream;

  @override
  bool get isLoggedIn => _isLoggedInSubject.value;

  @override
  String get authErrorMessage => _authExceptionDescription;

  @override
  void signInWithEmailAndPassword(String email, String password) {}

  @override
  void subscribeToAuthenticationUpdates() {
    _isLoggedInSubject.add(true);
  }

  @override
  void signOut() {
    _isLoggedInSubject.add(false);
  }

  @override
  void dispose() {}
}
