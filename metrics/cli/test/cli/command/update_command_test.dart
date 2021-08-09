// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:args/command_runner.dart';
import 'package:cli/cli/command/update_command.dart';
import 'package:cli/cli/updater/config/factory/update_config_factory.dart';
import 'package:cli/cli/updater/factory/updater_factory.dart';
import 'package:cli/cli/updater/updater.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../test_utils/matchers.dart';
import '../../test_utils/mocks/update_config_mock.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("UpdateCommand", () {
    const configPath = 'configPath';
    const configArgument = '--config-file=$configPath';

    final updateConfigFactory = _UpdateConfigFactoryMock();
    final updater = _UpdaterMock();
    final updaterFactory = _UpdaterFactoryStub(updater);

    final runner = CommandRunner('test', 'test');
    final updateCommand = UpdateCommand(
      updaterFactory,
      updateConfigFactory: updateConfigFactory,
    );
    final commandName = updateCommand.name;

    setUpAll(() {
      runner.addCommand(updateCommand);
    });

    tearDown(() {
      reset(updateConfigFactory);
      reset(updater);
    });

    test(
      "throws an ArgumentError if the given updater factory is null",
      () {
        expect(
          () => UpdateCommand(null),
          throwsArgumentError,
        );
      },
    );

    test(
      "successfully creates an instance if the given update config factory is null",
      () {
        expect(
          () => UpdateCommand(
            updaterFactory,
            updateConfigFactory: null,
          ),
          returnsNormally,
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
        final runner = CommandRunner('test', 'test');
        final updaterFactory = _UpdaterFactoryMock();
        final updateCommand = UpdateCommand(
          updaterFactory,
          updateConfigFactory: updateConfigFactory,
        );

        runner.addCommand(updateCommand);
        when(updaterFactory.create()).thenReturn(updater);

        await runner.run([updateCommand.name, configArgument]);

        verify(updaterFactory.create()).called(once);
      },
    );

    test(
      ".run() uses the update config factory to create the update config",
      () async {
        await runner.run([commandName, configArgument]);

        verify(updateConfigFactory.create(configPath)).called(once);
      },
    );

    test(
      ".run() uses the updater to update the deployed Metrics components",
      () async {
        final updateConfig = UpdateConfigMock();

        when(updateConfigFactory.create(configPath)).thenReturn(updateConfig);

        await runner.run([commandName, configArgument]);

        verify(updater.update(updateConfig)).called(once);
      },
    );
  });
}

/// A stub class for an [UpdaterFactory] class providing test implementation
/// for methods.
class _UpdaterFactoryStub extends UpdaterFactory {
  /// An [Updater] class this stub creates.
  final Updater updater;

  /// Creates an instance of the [_UpdaterFactoryStub].
  _UpdaterFactoryStub(this.updater);

  @override
  Updater create() {
    return updater;
  }
}

class _UpdateConfigFactoryMock extends Mock implements UpdateConfigFactory {}

class _UpdaterMock extends Mock implements Updater {}

class _UpdaterFactoryMock extends Mock implements UpdaterFactory {}
