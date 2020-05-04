/// Represents the user credentials for the Metrics application.
class UserCredentials {
  final String email;
  final String password;

  /// Creates the [UserCredentials].
  ///
  /// The [email] and [password] must not be null.
  UserCredentials({
    this.email,
    this.password,
  }) {
    ArgumentError.notNull(email);
    ArgumentError.notNull(password);
  }
}
