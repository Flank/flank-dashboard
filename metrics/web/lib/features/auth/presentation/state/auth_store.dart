import 'package:rxdart/rxdart.dart';

/// The auth store for a user.
///
/// Stores [_isLoggedInSubject] stream to determine user's authentication status.
/// Provides the ability to sign in and sign out user from the app,
/// track the [isLoggedIn] status and authentication error message if any
class AuthStore {
  /// Stream that contains a user's authentication status.
  final BehaviorSubject<bool> _isLoggedInSubject = BehaviorSubject();
  
  /// Returns a stream of a user's authentication status.
  Stream<bool> get loggedInStream => _isLoggedInSubject.stream;

  /// Determines if a user is authenticated.
  bool get isLoggedIn => _isLoggedInSubject.value;

  /// Returns a string, containing an auth error message.
  String get authErrorMessage => _authExceptionDescription;

  /// Contains text description of any authentication exception that may occur.
  String _authExceptionDescription;

  /// Subscribes to a user authentication updates
  /// to get notified when the user got signed in or signed out.
  void subscribeToAuthenticationUpdates() {
    _isLoggedInSubject.add(false);
  }

  /// Signs in user to the app using an [email] and a [password].
  void signInWithEmailAndPassword(String email, String password) {
    _isLoggedInSubject.add(true);
  }

  /// Signs out the user from the app.
  void signOut() {
    _isLoggedInSubject.add(false);
  }

  /// Cancels all created subscriptions.
  void dispose() {
    _isLoggedInSubject.close();
  }
}
