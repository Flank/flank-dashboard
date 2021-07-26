// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/util/dependencies/dependencies.dart';
import 'package:cli/util/dependencies/factory/dependencies_factory.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:yaml_map/yaml_map.dart';

import '../../../test_utils/mocks/file_helper_mock.dart';
import '../../../test_utils/mocks/file_mock.dart';

void main() {
  group("DependenciesFactory", () {
    const service = 'service';
    const recommendedVersion = 'version';
    const installUrl = 'url';
    const yamlFile = '''
$service:
    recommended_version: $recommendedVersion
    install_url: $installUrl
    ''';

    final file = FileMock();
    final fileHelper = FileHelperMock();
    final dependenciesFactory = DependenciesFactoryStub(
      file,
      fileHelper,
    );

    tearDown(() {
      reset(file);
      reset(fileHelper);
    });

    test(
      "creates a new instance",
      () {
        expect(() => const DependenciesFactory(), returnsNormally);
      },
    );

    test(
      ".create() return null if the given file does not exist",
      () {
        when(file.existsSync()).thenReturn(false);

        final dependencies = dependenciesFactory.create('path');

        expect(dependencies, isNull);
      },
    );

    test(
      ".create() successfully creates a Dependencies from the given file",
      () {
        when(file.existsSync()).thenReturn(true);
        when(file.readAsStringSync()).thenReturn(yamlFile);

        final dependencies = dependenciesFactory.create('path');

        expect(dependencies, isA<Dependencies>());
      },
    );

    test(
      ".create() correctly parses the given file",
      () {
        when(file.existsSync()).thenReturn(true);
        when(file.readAsStringSync()).thenReturn(yamlFile);

        final dependencies = dependenciesFactory.create('path');
        final dependency = dependencies.getFor(service);

        expect(dependency.recommendedVersion, equals(recommendedVersion));
        expect(dependency.installUrl, equals(installUrl));
      },
    );
  });
}

/// A stub class for a [DependenciesFactory] class providing test
/// implementation for methods.
class DependenciesFactoryStub extends DependenciesFactory {
  /// A file mock to use for testing purposes.
  final FileMock fileMock;

  /// A file helper mock to use for testing purposes.
  final FileHelperMock fileHelperMock;

  /// Creates a new instance of the [DependenciesFactoryStub].
  DependenciesFactoryStub(
    this.fileMock,
    this.fileHelperMock,
  );

  @override
  Dependencies create(String path) {
    if (fileMock?.existsSync() == false) {
      return null;
    }

    const parser = YamlMapParser();
    final parsedYaml = parser.parse(fileMock.readAsStringSync());

    return Dependencies.fromMap(parsedYaml);
  }
}
