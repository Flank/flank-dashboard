import 'package:metrics/features/auth/presentation/state/auth_store.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

/// Mock implementation of the [AuthStore] ensures that a user is already logged in into the app.
class SignedInAuthStoreMock extends Mock implements AuthStore {
  final BehaviorSubject<bool> _isLoggedInSubject = BehaviorSubject();

  @override
  bool get isLoggedIn => _isLoggedInSubject.value;

  SignedInAuthStoreMock() {
    when(subscribeToAuthenticationUpdates())
        .thenAnswer((_) => _isLoggedInSubject.add(true));
    when(loggedInStream).thenAnswer((_) => _isLoggedInSubject.stream);
    when(signOut()).thenAnswer((_) => _isLoggedInSubject.add(false));
  }
}
