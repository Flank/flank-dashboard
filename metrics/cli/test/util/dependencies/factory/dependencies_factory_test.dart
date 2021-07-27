// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/util/dependencies/factory/dependencies_factory.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../cli/updater/config/parser/update_config_parser_test.dart';
import '../../../test_utils/matchers.dart';
import '../../../test_utils/mocks/file_helper_mock.dart';
import '../../../test_utils/mocks/file_mock.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("DependenciesFactory", () {
    const path = 'path';
    const service = 'service';
    const recommendedVersion = 'version';
    const installUrl = 'url';

    final dependenciesMap = {
      service: {
        'recommended_version': recommendedVersion,
        'install_url': installUrl,
      }
    };
    final file = FileMock();
    final fileHelper = FileHelperMock();
    final yamlMapParser = YamlMapParserMock();

    final dependenciesFactory = DependenciesFactory(
      fileHelper: fileHelper,
      yamlMapParser: yamlMapParser,
    );

    tearDown(() {
      reset(file);
      reset(fileHelper);
      reset(yamlMapParser);
    });

    test(
      "successfully creates an instance if the given file helper is null",
      () {
        expect(
          () => DependenciesFactory(
            fileHelper: null,
            yamlMapParser: yamlMapParser,
          ),
          returnsNormally,
        );
      },
    );

    test(
      "successfully creates an instance if the given yaml map parser is null",
      () {
        expect(
          () => DependenciesFactory(
            fileHelper: fileHelper,
            yamlMapParser: null,
          ),
          returnsNormally,
        );
      },
    );

    test(
      ".create() throws an ArgumentError if the given path is null",
      () {
        expect(() => dependenciesFactory.create(null), throwsArgumentError);
      },
    );

    test(
      ".create() uses the given file helper to get the file by the given path",
      () {
        when(fileHelper.getFile(path)).thenReturn(file);
        when(file.existsSync()).thenReturn(true);

        dependenciesFactory.create(path);

        verify(fileHelper.getFile(path)).called(once);
      },
    );

    test(
      ".create() return null if the given file does not exist",
      () {
        when(fileHelper.getFile(path)).thenReturn(file);
        when(file.existsSync()).thenReturn(false);

        final dependencies = dependenciesFactory.create('path');

        expect(dependencies, isNull);
      },
    );

    test(
      ".create() uses the given YAML map parser to parse the file content",
      () {
        const fileContents = 'contents';
        when(fileHelper.getFile(path)).thenReturn(file);
        when(file.existsSync()).thenReturn(true);
        when(file.readAsStringSync()).thenReturn(fileContents);

        dependenciesFactory.create('path');

        verify(yamlMapParser.parse(fileContents)).called(once);
      },
    );

    test(
      ".create() creates a dependencies instance from the map returned by the given YAML map parser",
      () {
        when(fileHelper.getFile(path)).thenReturn(file);
        when(file.existsSync()).thenReturn(true);
        when(yamlMapParser.parse(any)).thenReturn(dependenciesMap);

        final dependencies = dependenciesFactory.create('path');
        final dependency = dependencies.getFor(service);

        expect(dependency.recommendedVersion, equals(recommendedVersion));
        expect(dependency.installUrl, equals(installUrl));
      },
    );
  });
}
