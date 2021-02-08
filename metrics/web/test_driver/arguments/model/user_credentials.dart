// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

/// Represents the user credentials for the Metrics application.
class UserCredentials {
  /// A user email environment variable name.
  static const String emailEnvVariableName = 'USER_EMAIL';

  /// A user password environment variable name.
  static const String passwordEnvVariableName = 'USER_PASSWORD';

  /// An email used to log in to the app.
  final String email;

  /// A password used to log in to the app.
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

  /// Creates the [UserCredentials] from the dart environment.
  factory UserCredentials.fromEnvironment() {
    const email = String.fromEnvironment(emailEnvVariableName);
    const password = String.fromEnvironment(passwordEnvVariableName);

    return UserCredentials(
      email: email,
      password: password,
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
