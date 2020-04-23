import 'package:metrics/features/auth/presentation/state/auth_store.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

/// Fake implementation of the [AuthStore] ensures that a user is already logged in into the app.
class SignedInAuthStoreFake extends Fake implements AuthStore {
  final BehaviorSubject<bool> _isLoggedInSubject = BehaviorSubject();

  @override
  bool get isLoggedIn => _isLoggedInSubject.value;

  @override
  Stream<bool> get loggedInStream => _isLoggedInSubject.stream;

  @override
  String get authErrorMessage => _authExceptionDescription;

  String _authExceptionDescription;

  @override
  void subscribeToAuthenticationUpdates() {
    _isLoggedInSubject.add(true);
  }

  @override
  void signOut() {
    _isLoggedInSubject.add(false);
  }
}
