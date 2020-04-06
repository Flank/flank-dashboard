import 'package:rxdart/rxdart.dart';

/// Metrics store for a user.
class UserMetricsStore {
  /// Stream that contains a user's authentication status
  final BehaviorSubject<bool> _isLoggedInSubject = BehaviorSubject();

  /// Determines if a user is authenticated, based on the [_isLoggedInSubject]'s value.
  bool get isLoggedIn => _isLoggedInSubject.value;

  /// Contains text description of any authentication exception that may occur.
  String _authExceptionDescription;

  /// Mocks subscribe to a user changes and updates the [_isLoggedInSubject]'s value.
  void subscribeToUserUpdates() {
    _isLoggedInSubject.add(false);
  }

  /// Mocks a user sign in to the app using an [email] and a [password].
  void signInWithEmailAndPassword(String email, String password) {
    _isLoggedInSubject.add(true);
  }

  /// Mocks sign out the user from the app and updates the [_isLoggedInSubject]'s value.
  void signOut() {
    _isLoggedInSubject.add(false);
  }

  /// Cancels all created subscriptions.
  void dispose() {
    _isLoggedInSubject.close();
  }
}
