import 'package:links_checker/common/command/links_checker_command.dart';
import 'package:links_checker/common/runner/links_checker_runner.dart';
import 'package:test/test.dart';

void main() {
  group("LinksCheckerRunner", () {
    test("successfully creates an instance", () {
      expect(() => LinksCheckerRunner(), returnsNormally);
    });

    test("contains a links checker command", () {
      final runner = LinksCheckerRunner();

      expect(
        runner.commands.values,
        contains(isA<LinksCheckerCommand>()),
      );
    });
  });
}
