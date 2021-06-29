// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/cli/updater/config/model/firebase_config.dart';
import 'package:cli/cli/updater/config/model/sentry_config.dart';
import 'package:cli/cli/updater/config/model/update_config.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("UpdateConfig", () {
    const firebaseAuthToken = 'firebaseAuthToken';
    const projectId = 'projectId';
    const googleSignInClientId = 'googleSignInClientId';
    const sentryAuthToken = 'sentryAuthToken';
    const organizationSlug = 'organizationSlug';
    const projectSlug = 'projectSlug';
    const projectDsn = 'projectDsn';
    const releaseName = 'releaseName';
    const firebaseJson = {
      'auth_token': firebaseAuthToken,
      'project_id': projectId,
      'google_sign_in_client_id': googleSignInClientId,
    };
    const sentryJson = {
      'auth_token': sentryAuthToken,
      'organization_slug': organizationSlug,
      'project_slug': projectSlug,
      'project_dsn': projectDsn,
      'release_name': releaseName,
    };
    const json = {
      'firebase': firebaseJson,
      'sentry': sentryJson,
    };

    final firebaseConfig = FirebaseConfig(
      authToken: firebaseAuthToken,
      projectId: projectId,
      googleSignInClientId: googleSignInClientId,
    );
    final sentryConfig = SentryConfig(
      authToken: sentryAuthToken,
      organizationSlug: organizationSlug,
      projectSlug: projectSlug,
      projectDsn: projectDsn,
      releaseName: releaseName,
    );

    test("throws an ArgumentError if the given auth token is null", () {
      expect(
        () => UpdateConfig(firebaseConfig: null, sentryConfig: sentryConfig),
        throwsArgumentError,
      );
    });

    test("creates an instance with the given values", () {
      final config = UpdateConfig(
        firebaseConfig: firebaseConfig,
        sentryConfig: sentryConfig,
      );

      expect(config.firebaseConfig, equals(firebaseConfig));
      expect(config.sentryConfig, equals(sentryConfig));
    });

    test(".fromJson() returns null if the given json is null", () {
      final config = UpdateConfig.fromJson(null);

      expect(config, isNull);
    });

    test(".fromJson() creates an instance from a json map", () {
      final expectedConfig = UpdateConfig(
        firebaseConfig: firebaseConfig,
        sentryConfig: sentryConfig,
      );

      final config = UpdateConfig.fromJson(json);

      expect(config, equals(expectedConfig));
    });

    test("equals to another UpdateConfig with the same parameters", () {
      final expected = UpdateConfig(
        firebaseConfig: firebaseConfig,
        sentryConfig: sentryConfig,
      );
      final updateConfig = UpdateConfig(
        firebaseConfig: firebaseConfig,
        sentryConfig: sentryConfig,
      );

      expect(updateConfig, equals(expected));
    });
  });
}
