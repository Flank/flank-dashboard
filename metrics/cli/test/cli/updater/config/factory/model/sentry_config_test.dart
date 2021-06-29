// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/cli/updater/config/model/sentry_config.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("SentryConfig", () {
    const authToken = 'authToken';
    const organizationSlug = 'organizationSlug';
    const projectSlug = 'projectSlug';
    const projectDsn = 'projectDsn';
    const releaseName = 'releaseName';
    const json = {
      'auth_token': authToken,
      'organization_slug': organizationSlug,
      'project_slug': projectSlug,
      'project_dsn': projectDsn,
      'release_name': releaseName,
    };

    test("throws an ArgumentError if the given auth token is null", () {
      expect(
        () => SentryConfig(
          authToken: null,
          organizationSlug: organizationSlug,
          projectSlug: projectSlug,
          projectDsn: projectDsn,
          releaseName: releaseName,
        ),
        throwsArgumentError,
      );
    });

    test("throws an ArgumentError if the given organization slug is null", () {
      expect(
        () => SentryConfig(
          authToken: authToken,
          organizationSlug: null,
          projectSlug: projectSlug,
          projectDsn: projectDsn,
          releaseName: releaseName,
        ),
        throwsArgumentError,
      );
    });

    test("throws an ArgumentError if the given project slug is null", () {
      expect(
        () => SentryConfig(
          authToken: authToken,
          organizationSlug: organizationSlug,
          projectSlug: null,
          projectDsn: projectDsn,
          releaseName: releaseName,
        ),
        throwsArgumentError,
      );
    });

    test("throws an ArgumentError if the given project dsn is null", () {
      expect(
        () => SentryConfig(
          authToken: authToken,
          organizationSlug: organizationSlug,
          projectSlug: projectSlug,
          projectDsn: null,
          releaseName: releaseName,
        ),
        throwsArgumentError,
      );
    });

    test("throws an ArgumentError if the given release name is null", () {
      expect(
        () => SentryConfig(
          authToken: authToken,
          organizationSlug: organizationSlug,
          projectSlug: projectSlug,
          projectDsn: projectDsn,
          releaseName: null,
        ),
        throwsArgumentError,
      );
    });

    test("creates an instance with the given values", () {
      final config = SentryConfig(
        authToken: authToken,
        organizationSlug: organizationSlug,
        projectSlug: projectSlug,
        projectDsn: projectDsn,
        releaseName: releaseName,
      );

      expect(config.authToken, equals(authToken));
      expect(config.organizationSlug, equals(organizationSlug));
      expect(config.projectSlug, equals(projectSlug));
      expect(config.projectDsn, equals(projectDsn));
      expect(config.releaseName, equals(releaseName));
    });

    test(".fromJson() returns null if the given json is null", () {
      final config = SentryConfig.fromJson(null);

      expect(config, isNull);
    });

    test(".fromJson() creates an instance from a json map", () {
      final expectedConfig = SentryConfig(
        authToken: authToken,
        organizationSlug: organizationSlug,
        projectSlug: projectSlug,
        projectDsn: projectDsn,
        releaseName: releaseName,
      );

      final config = SentryConfig.fromJson(json);

      expect(config, equals(expectedConfig));
    });

    test("equals to another UpdateConfig with the same parameters", () {
      final expected = SentryConfig(
        authToken: authToken,
        organizationSlug: organizationSlug,
        projectSlug: projectSlug,
        projectDsn: projectDsn,
        releaseName: releaseName,
      );
      final sentryConfig = SentryConfig(
        authToken: authToken,
        organizationSlug: organizationSlug,
        projectSlug: projectSlug,
        projectDsn: projectDsn,
        releaseName: releaseName,
      );

      expect(sentryConfig, equals(expected));
    });
  });
}
