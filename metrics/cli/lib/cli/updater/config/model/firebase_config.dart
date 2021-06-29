// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';

/// A class that represents a Firebase configuration.
class FirebaseConfig extends Equatable {
  /// A Firebase access token that is used to authenticate CLI requests.
  final String authToken;

  /// A unique identifier of the Firebase project.
  final String projectId;

  /// A Google OAuth 2.0 client ID.
  final String googleSignInClientId;

  @override
  List<Object> get props => [authToken, projectId, googleSignInClientId];

  /// Creates a new instance of the [FirebaseConfig] with the given parameters.
  ///
  /// Throws an [ArgumentError] if the given [authToken] is `null`.
  /// Throws an [ArgumentError] if the given [projectId] is `null`.
  FirebaseConfig({
    this.authToken,
    this.projectId,
    this.googleSignInClientId,
  }) {
    ArgumentError.checkNotNull(authToken, 'authToken');
    ArgumentError.checkNotNull(projectId, 'projectId');
  }

  /// Creates a new instance of the [FirebaseConfig] from the given [json].
  ///
  /// Returns `null` if the given [json] is `null`.
  factory FirebaseConfig.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return FirebaseConfig(
      authToken: json['auth_token'] as String,
      projectId: json['project_id'] as String,
      googleSignInClientId: json['google_sign_in_client_id'] as String,
    );
  }
}
