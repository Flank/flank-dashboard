import 'package:metrics/features/auth/presentation/state/user_store.dart';

/// Stub of [UserStore] that emulates presence of auth message error.
class SignInErrorUserStoreStub extends UserStore {
  static const String errorMessage = "Unknown error";

  @override
  String get authErrorMessage => _authExceptionDescription;

  String _authExceptionDescription;

  @override
  void signInWithEmailAndPassword(String email, String password) {
    _authExceptionDescription = errorMessage;
  }
}