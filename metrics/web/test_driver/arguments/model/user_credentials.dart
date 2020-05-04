/// Represents the user credentials for the Metrics application.
class UserCredentials {
  /// A user email environment variable name.
  static const String emailEnvVariableName = 'USER_EMAIL';

  /// A user password environment variable name.
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

  /// Creates the [UserCredentials] from the given [map].
  factory UserCredentials.fromMap(Map<String, String> map) {
    return UserCredentials(
      email: map[emailEnvVariableName],
      password: map[passwordEnvVariableName],
    );
  }

  /// Maps the [UserCredentials] to the [Map].
  Map<String, String> toMap() {
    return {
      emailEnvVariableName: email,
      passwordEnvVariableName: password,
    };
  }
}
