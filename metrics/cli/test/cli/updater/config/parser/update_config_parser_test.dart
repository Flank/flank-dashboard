// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/cli/updater/config/model/update_config.dart';
import 'package:cli/cli/updater/config/parser/update_config_parser.dart';
import 'package:test/test.dart';

void main() {
  group("UpdateConfigParser", () {
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
    const configParser = UpdateConfigParser();

    test(
      ".parse() throws an ArgumentError if the given config yaml is null",
      () {
        expect(() => configParser.parse(null), throwsArgumentError);
      },
    );

    test(
      ".parse() creates an UpdateConfig from the given config yaml string",
      () {
        final expected = UpdateConfig.fromJson(json);

        final config = configParser.parse(json.toString());

        expect(config, equals(expected));
      },
    );
  });
}
