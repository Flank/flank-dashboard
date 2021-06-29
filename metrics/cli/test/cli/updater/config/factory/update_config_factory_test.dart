// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:cli/cli/updater/config/model/firebase_config.dart';
import 'package:cli/cli/updater/config/model/sentry_config.dart';
import 'package:cli/cli/updater/config/model/update_config.dart';
import 'package:cli/cli/updater/config/parser/update_config_parser.dart';
import 'package:cli/cli/updater/config/factory/update_config_factory.dart';
import 'package:cli/util/file/file_helper.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matchers.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("RawIntegrationConfigFactory", () {
    const configPath = 'configPath';
    const content = 'content';
    const firebaseAuthToken = 'firebaseAuthToken';
    const projectId = 'projectId';
    const googleSignInClientId = 'googleSignInClientId';
    const sentryAuthToken = 'sentryAuthToken';
    const organizationSlug = 'organizationSlug';
    const projectSlug = 'projectSlug';
    const projectDsn = 'projectDsn';
    const releaseName = 'releaseName';

    final fileHelper = _FileHelperMock();
    final configParser = _UpdateConfigParserMock();
    final file = _FileMock();
    final configFactory = UpdateConfigFactory(
      fileHelper: fileHelper,
      configParser: configParser,
    );
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
        final rawConfigFactory = UpdateConfigFactory(
          fileHelper: null,
          configParser: configParser,
        );

        expect(rawConfigFactory.fileHelper, isNotNull);
      },
    );

    test(
      "creates an instance with the default raw config parser, if the given one is null",
      () {
        final rawConfigFactory = UpdateConfigFactory(
          fileHelper: fileHelper,
          configParser: null,
        );

        expect(rawConfigFactory.configParser, isNotNull);
      },
    );

    test(
      ".create() throws an ArgumentError if the given path is null",
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
      ".create() returns the config parsed by the raw integration config parser",
      () {
        final expectedConfig = UpdateConfig(
          firebaseConfig: firebaseConfig,
          sentryConfig: sentryConfig,
        );

        when(configParser.parse(any)).thenReturn(expectedConfig);
        whenReadContent().thenReturn(content);

        final config = configFactory.create(configPath);

        expect(config, equals(expectedConfig));
      },
    );
  });
}

class _FileHelperMock extends Mock implements FileHelper {}

class _UpdateConfigParserMock extends Mock implements UpdateConfigParser {}

class _FileMock extends Mock implements File {}
