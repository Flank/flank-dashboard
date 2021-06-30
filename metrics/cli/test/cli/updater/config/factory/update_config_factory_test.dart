// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:cli/cli/updater/config/model/update_config.dart';
import 'package:cli/cli/updater/config/parser/update_config_parser.dart';
import 'package:cli/cli/updater/config/factory/update_config_factory.dart';
import 'package:cli/util/file/file_helper.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matchers.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("UpdateConfigFactory", () {
    const configPath = 'configPath';
    const content = 'content';

    final fileHelper = _FileHelperMock();
    final configParser = _UpdateConfigParserMock();
    final file = _FileMock();
    final configFactory = UpdateConfigFactory(
      fileHelper: fileHelper,
      configParser: configParser,
    );

    tearDown(() {
      reset(fileHelper);
      reset(configParser);
      reset(file);
    });

    PostExpectation<String> whenReadContent({String withConfigPath}) {
      final path = withConfigPath ?? configPath;

      when(fileHelper.getFile(path)).thenReturn(file);
      return when(file.readAsStringSync());
    }

    test(
      "creates an instance with the given parameters",
      () {
        final configFactory = UpdateConfigFactory(
          fileHelper: fileHelper,
          configParser: configParser,
        );

        expect(configFactory.fileHelper, equals(fileHelper));
        expect(configFactory.configParser, equals(configParser));
      },
    );

    test(
      "creates an instance with the default file helper, if the given one is null",
      () {
        final updateConfigFactory = UpdateConfigFactory(
          fileHelper: null,
          configParser: configParser,
        );

        expect(updateConfigFactory.fileHelper, isNotNull);
      },
    );

    test(
      "creates an instance with the default update config parser, if the given one is null",
      () {
        final updateConfigFactory = UpdateConfigFactory(
          fileHelper: fileHelper,
          configParser: null,
        );

        expect(updateConfigFactory.configParser, isNotNull);
      },
    );

    test(
      ".create() throws an ArgumentError if the given config path is null",
      () {
        expect(() => configFactory.create(null), throwsArgumentError);
      },
    );

    test(
      ".create() gets the configuration file using the given file helper",
      () {
        whenReadContent().thenReturn(content);

        configFactory.create(configPath);

        verify(fileHelper.getFile(configPath)).called(once);
      },
    );

    test(
      ".create() reads the configuration file",
      () {
        whenReadContent().thenReturn(content);

        configFactory.create(configPath);

        verify(file.readAsStringSync()).called(once);
      },
    );

    test(
      ".create() parses the config file content using the given config parser",
      () {
        whenReadContent().thenReturn(content);

        configFactory.create(configPath);

        verify(configParser.parse(content)).called(once);
      },
    );

    test(
      ".create() returns the config parsed by the update config parser",
      () {
        const json = {
          'firebase': {
            'auth_token': 'token',
            'project_id': 'projectId',
            'google_sign_in_client_id': 'clientId',
          },
          'sentry': {
            'auth_token': 'token',
            'organization_slug': 'orgSlug',
            'project_slug': 'projectSlug',
            'project_dsn': 'projectDsn',
            'release_name': 'releaseName'
          },
        };

        final expectedConfig = UpdateConfig.fromJson(json);

        whenReadContent().thenReturn(content);
        when(configParser.parse(content)).thenReturn(expectedConfig);

        final config = configFactory.create(configPath);

        expect(config, equals(expectedConfig));
      },
    );
  });
}

class _FileHelperMock extends Mock implements FileHelper {}

class _UpdateConfigParserMock extends Mock implements UpdateConfigParser {}

class _FileMock extends Mock implements File {}
