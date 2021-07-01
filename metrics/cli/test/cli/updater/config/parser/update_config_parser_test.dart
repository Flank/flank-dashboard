// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/cli/updater/config/parser/update_config_parser.dart';
import 'package:cli/common/model/config/update_config.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:yaml_map/yaml_map.dart';

import '../../../../test_utils/matchers.dart';

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

    final yamlMapParserMock = YamlMapParserMock();

    tearDown(() {
      reset(yamlMapParserMock);
    });

    test(
      ".parse() throws an ArgumentError if the given config yaml is null",
      () {
        expect(() => configParser.parse(null), throwsArgumentError);
      },
    );

    test(
      ".parse() parses the given content using the given parser",
      () {
        const content = 'content';

        final configParser = UpdateConfigParser(
          parser: yamlMapParserMock,
        );

        configParser.parse(content);

        verify(yamlMapParserMock.parse(content)).called(once);
      },
    );

    test(
      ".parse() creates an UpdateConfig from the given config yaml string",
      () {
        final expected = UpdateConfig.fromJson(json);
        final configParser = UpdateConfigParser(
          parser: yamlMapParserMock,
        );

        when(yamlMapParserMock.parse(any)).thenReturn(json);

        final config = configParser.parse('content');

        expect(config, equals(expected));
      },
    );
  });
}

class YamlMapParserMock extends Mock implements YamlMapParser {}
