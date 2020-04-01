import 'package:rxdart/rxdart.dart';

/// Metrics store for a user.
class UserMetricsStore {
  /// Creates a [_userUpdates] stream that contains a user's authentication status
  final BehaviorSubject<bool> _userUpdates = BehaviorSubject();

  /// Determines if a user is authenticated, based on the [_userUpdates]'s value.
  bool get isLoggedIn => _userUpdates.value;

  /// Contains text description of any authentication exception that may occur.
  String _authExceptionDescription;

  /// Mocks subscribe to a user changes and updates the [_userUpdates]'s value.
  Future<void> subscribeToUserUpdates() async {
    _userUpdates.add(false);
  }

  /// Mocks a user sign in to the app using an [email] and a [password].
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    _userUpdates.add(true);
  }

  /// Mocks sign out the user from the app and updates the [_userUpdates]'s value.
  Future<void> signOut() async {
    _userUpdates.add(false);
  }

  /// Cancels all created subscriptions.
  void dispose() {
    _userUpdates.close();
  }
}
