import 'package:ci_integration/ci_integration/command/ci_integration_command.dart';
import 'package:ci_integration/common/logger/logger.dart';
import 'package:test/test.dart';

void main() {
  group("CiIntegrationCommand", () {
    test(
      "should throw ArgumentError trying to create instance with null logger",
      () {
        expect(() => CiIntegrationCommandTestbed(null), throwsArgumentError);
      },
    );
  });
}

/// A testbed class for a [CiIntegrationCommand] abstract class providing
/// a test implementation.
class CiIntegrationCommandTestbed extends CiIntegrationCommand {
  CiIntegrationCommandTestbed(Logger logger) : super(logger);

  @override
  String get description => null;

  @override
  String get name => null;
}
