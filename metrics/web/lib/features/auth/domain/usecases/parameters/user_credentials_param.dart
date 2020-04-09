import 'package:meta/meta.dart';

/// Represents the user credentials parameter.
class UserCredentialsParam {
  final String email;
  final String password;

  /// Creates [UserCredentialsParam] with the given [email] and [password].
  ///
  /// Throws an [AssertionError] if either [email] or [password] is null.
  UserCredentialsParam({
    @required this.email,
    @required this.password,
  })  : assert(email != null),
        assert(password != null);
}
