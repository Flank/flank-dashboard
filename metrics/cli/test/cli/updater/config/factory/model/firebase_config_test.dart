// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/cli/updater/config/model/firebase_config.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("FirebaseConfig", () {
    const authToken = 'authToken';
    const projectId = 'projectId';
    const googleSignInClientId = 'googleSignInClientId';
    const json = {
      'auth_token': authToken,
      'project_id': projectId,
      'google_sign_in_client_id': googleSignInClientId,
    };

    test("throws an ArgumentError if the given auth token is null", () {
      expect(
        () => FirebaseConfig(
          authToken: null,
          projectId: projectId,
          googleSignInClientId: googleSignInClientId,
        ),
        throwsArgumentError,
      );
    });

    test("throws an ArgumentError if the given project id is null", () {
      expect(
        () => FirebaseConfig(
          authToken: authToken,
          projectId: null,
          googleSignInClientId: googleSignInClientId,
        ),
        throwsArgumentError,
      );
    });

    test("creates an instance with the given values", () {
      final config = FirebaseConfig(
        authToken: authToken,
        projectId: projectId,
        googleSignInClientId: googleSignInClientId,
      );

      expect(config.authToken, equals(authToken));
      expect(config.projectId, equals(projectId));
      expect(config.googleSignInClientId, equals(googleSignInClientId));
    });

    test(".fromJson() returns null if the given json is null", () {
      final config = FirebaseConfig.fromJson(null);

      expect(config, isNull);
    });

    test(".fromJson() creates an instance from a json map", () {
      final expectedConfig = FirebaseConfig(
        authToken: authToken,
        projectId: projectId,
        googleSignInClientId: googleSignInClientId,
      );

      final config = FirebaseConfig.fromJson(json);

      expect(config, equals(expectedConfig));
    });

    test("equals to another UpdateConfig with the same parameters", () {
      final expected = FirebaseConfig(
        authToken: authToken,
        projectId: projectId,
        googleSignInClientId: googleSignInClientId,
      );
      final firebaseConfig = FirebaseConfig(
        authToken: authToken,
        projectId: projectId,
        googleSignInClientId: googleSignInClientId,
      );

      expect(firebaseConfig, equals(expected));
    });
  });
}
