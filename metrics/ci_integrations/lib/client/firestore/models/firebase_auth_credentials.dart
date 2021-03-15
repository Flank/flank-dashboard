// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:firedart/firedart.dart';
import 'package:meta/meta.dart';

/// A class that represents [FirebaseAuth] credentials.
class FirebaseAuthCredentials extends Equatable {
  /// A Firebase API key that is used to access the project using Firebase API.
  final String apiKey;

  /// An email of the Firebase user.
  final String email;

  /// A password of the Firebase user.
  final String password;

  @override
  List<Object> get props => [apiKey, email, password];

  /// Creates a new instance of the [FirebaseAuthCredentials] with the given
  /// parameters.
  ///
  /// All parameters are required.
  ///
  /// Throws an [ArgumentError] if any of the given parameters is `null`.
  FirebaseAuthCredentials({
    @required this.apiKey,
    @required this.email,
    @required this.password,
  }) {
    ArgumentError.checkNotNull(apiKey, 'apiKey');
    ArgumentError.checkNotNull(email, 'email');
    ArgumentError.checkNotNull(password, 'password');
  }
}
