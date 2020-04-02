import 'package:ci_integration/ci_integration/command/sync_command.dart';
import 'package:ci_integration/common/logger/logger.dart';
import 'package:test/test.dart';

void main() {
  group("SyncCommand", () {
    final syncCommand = SyncCommand(const Logger());

    test("should has the 'config-file' option", () {
      final argParser = syncCommand.argParser;
      final options = argParser.options;

      expect(options, contains('config-file'));
    });
  });
}
