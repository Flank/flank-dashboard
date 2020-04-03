import 'package:ci_integration/ci_integration/command/ci_integration_command.dart';
import 'package:ci_integration/ci_integration/runner/ci_integration_runner.dart';
import 'package:ci_integration/common/logger/logger.dart';
import 'package:test/test.dart';

import '../test_util/stub/logger_stub.dart';

void main() {
  group("CiIntegrationCommand", () {
    const optionName = 'test-option';

    final logger = LoggerStub();
    final command = CiIntegrationCommandStub(logger);
    final runner = CiIntegrationsRunner(logger);

    setUpAll(() {
      runner.addCommand(command);
      command.argParser.addOption(optionName);
    });

    test(
      "should throw ArgumentError trying to create instance with null logger",
      () {
        expect(() => CiIntegrationCommandStub(null), throwsArgumentError);
      },
    );

    test(
      "getOptionValue() should return null if option was not parsed",
      () async {
        await runner.run(['test']);
        final optionValue = command.getOptionValue(optionName);

        expect(optionValue, isNull);
      },
    );

    test(
      "getOptionValue() should return null if option was not parsed",
      () async {
        const optionValue = 'optionValue';
        await runner.run(['test', '--$optionName', optionValue]);
        final parsed = command.getOptionValue(optionName);

        expect(parsed, equals(optionValue));
      },
    );
  });
}

/// A stub class for a [CiIntegrationCommand] abstract class providing
/// a test implementation.
class CiIntegrationCommandStub extends CiIntegrationCommand {
  @override
  String get description => 'test description';

  @override
  String get name => 'test';

  CiIntegrationCommandStub(Logger logger) : super(logger);

  @override
  void run() {}
}
