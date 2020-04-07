import 'package:rxdart/rxdart.dart';

/// Store for a user.
class UserStore {
  /// Stream that contains a user's authentication status.
  final BehaviorSubject<bool> _isLoggedInSubject = BehaviorSubject();
  
  /// Returns a stream of a user's authentication status.
  Stream get loggedInStream => _isLoggedInSubject.stream;

  /// Determines if a user is authenticated.
  bool get isLoggedIn => _isLoggedInSubject.value;

  /// Contains text description of any authentication exception that may occur.
  String _authExceptionDescription;

  /// Subscribes to a current user updates to get notified when the user got signed in.
  void subscribeToUserUpdates() {
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
