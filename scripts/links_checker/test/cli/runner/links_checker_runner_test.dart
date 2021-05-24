// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:links_checker/cli/command/links_checker_command.dart';
import 'package:links_checker/cli/runner/links_checker_runner.dart';
import 'package:test/test.dart';

void main() {
  group("LinksCheckerRunner", () {
    test("successfully creates an instance", () {
      expect(() => LinksCheckerRunner(), returnsNormally);
    });

    test(".executableName contains a non-empty name of a tool", () {
      final runner = LinksCheckerRunner();

      final description = runner.executableName;

      expect(description, isNotEmpty);
    });

    test(".description contains a non-empty description of a tool", () {
      final runner = LinksCheckerRunner();

      final description = runner.description;

      expect(description, isNotEmpty);
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
