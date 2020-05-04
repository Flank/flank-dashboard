/// Represents the user credentials for the Metrics application.
class UserCredentials {
  static const String emailEnvVariableName = 'USER_EMAIL';
  static const String passwordEnvVariableName = 'USER_PASSWORD';

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

  Map<String, String> toEnvironment() {
    return {
      emailEnvVariableName: email,
      passwordEnvVariableName: password,
    };
  }
}
