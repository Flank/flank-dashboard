import 'package:meta/meta.dart';

/// Represents the user credential parameters.
class UserCredentialsParam {
  final String email;
  final String password;

  /// Creates [UserCredentialsParam] with the given [email] amd [password].
  ///
  /// Throws an [AssertionError] if whether [email] or [password] is null.
  UserCredentialsParam({
    @required this.email,
    @required this.password,
  })  : assert(email != null),
        assert(password != null);
}
