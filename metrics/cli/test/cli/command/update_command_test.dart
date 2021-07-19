// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:args/args.dart';
import 'package:cli/cli/command/doctor_command.dart';
import 'package:cli/cli/command/update_command.dart';
import 'package:cli/cli/updater/config/factory/update_config_factory.dart';
import 'package:cli/cli/updater/factory/updater_factory.dart';
import 'package:cli/cli/updater/updater.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../test_utils/matchers.dart';
import '../../test_utils/mocks/update_config_mock.dart';

void main() {
  group("UpdateCommand", () {
    const configPath = 'configPath';

    final updaterFactory = _UpdaterFactoryMock();
    final updateConfigFactory = _UpdateConfigFactoryMock();
    final updater = _UpdaterMock();
    final updateCommand = _UpdateCommandStub(
      updaterFactory,
      updateConfigFactory,
      configPath: configPath,
    );

    PostExpectation<Updater> whenCreateUpdater() {
      return when(updaterFactory.create());
    }

    tearDown(() {
      reset(updaterFactory);
      reset(updateConfigFactory);
      reset(updater);
    });

    test(
      "throws an ArgumentError if the given updater factory is null",
      () {
        expect(
          () => DoctorCommand(null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".name equals to the 'update'",
      () {
        expect(updateCommand.name, equals('update'));
      },
    );

    test(
      ".description is not empty",
      () {
        final description = updateCommand.description;

        expect(description, isNotEmpty);
      },
    );

    test(
      "has the 'config-file' option",
      () {
        final argParser = updateCommand.argParser;

        expect(argParser.options, contains('config-file'));
      },
    );

    test(
      "'config-file' option has a non-empty help",
      () {
        final argParser = updateCommand.argParser;

        final option = argParser.options['config-file'];

        expect(option.help, isNotEmpty);
      },
    );

    test(
      "'config-file' option has a non-empty value help",
      () {
        final argParser = updateCommand.argParser;

        final option = argParser.options['config-file'];

        expect(option.valueHelp, isNotEmpty);
      },
    );

    test(
      ".run() creates updater using the given updater factory",
      () async {
        whenCreateUpdater().thenReturn(updater);

        await updateCommand.run();

        verify(updaterFactory.create()).called(once);
      },
    );

    test(
      ".run() uses the update config factory to create the update config",
      () async {
        whenCreateUpdater().thenReturn(updater);

        await updateCommand.run();

        verify(updateConfigFactory.create(configPath)).called(once);
      },
    );

    test(
      ".run() uses the updater to update the deployed Metrics components",
      () async {
        final updateConfig = UpdateConfigMock();

        whenCreateUpdater().thenReturn(updater);
        when(updateConfigFactory.create(configPath)).thenReturn(updateConfig);

        await updateCommand.run();

        verify(updater.update(updateConfig)).called(once);
      },
    );
  });
}

/// A stub class for an [UpdateCommand] class providing test implementation
/// for methods.
class _UpdateCommandStub extends UpdateCommand {
  /// A path to the configuration file to use in tests.
  final String configPath;

  @override
  ArgResults get argResults => _ArgResultsStub(configPath);

  /// Creates an instance of the [_UpdateCommandStub]
  /// with the given parameters.
  _UpdateCommandStub(
    UpdaterFactory updaterFactory,
    UpdateConfigFactory updateConfigFactory, {
    this.configPath,
  }) : super(updaterFactory, updateConfigFactory: updateConfigFactory);
}

/// A stub class for an [ArgResults] class providing test implementation
/// for methods.
class _ArgResultsStub implements ArgResults {
  /// A path to the configuration file to use in tests.
  final String configPath;

  /// Creates an instance of the [_ArgResultsStub] with the given [configPath].
  _ArgResultsStub(this.configPath);

  @override
  String operator [](String name) {
    return configPath;
  }

  @override
  List<String> get arguments => throw UnimplementedError();

  @override
  ArgResults get command => throw UnimplementedError();

  @override
  String get name => throw UnimplementedError();

  @override
  Iterable<String> get options => throw UnimplementedError();

  @override
  List<String> get rest => throw UnimplementedError();

  @override
  bool wasParsed(String name) => throw UnimplementedError();
}

class _UpdateConfigFactoryMock extends Mock implements UpdateConfigFactory {}

class _UpdaterMock extends Mock implements Updater {}

class _UpdaterFactoryMock extends Mock implements UpdaterFactory {}
