import 'package:rxdart/rxdart.dart';

import 'user_store_stub.dart';

class LoggedInUserStoreStub extends UserStoreStub {
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