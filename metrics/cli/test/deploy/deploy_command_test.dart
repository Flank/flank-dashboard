// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:args/command_runner.dart';
import 'package:deploy/deploy/deploy_command.dart';
import 'package:test/test.dart';

void main() {
  var runner;

  const _defaultUsage = '''
Usage: metrics <command> [arguments]

Global options:
-h, --help    Print this usage information.

Available commands:
  help   Display help information for metrics.

Run "metrics help <command>" for more information about a command.''';
  group("DeployCommand", () {
    setUpAll(() {
      runner = CommandRunner('metrics', 'Metrics installer.');
    });
    test(
      ".invocation has a sane default",
      () {
        expect(runner.invocation, equals('metrics <command> [arguments]'));
      },
    );
    test("returns the usage string", () {
      expect(runner.usage, equals('''
Metrics installer.

$_defaultUsage'''));
    });
    test("contains custom commands", () {
      runner.addCommand(DeployCommand());
      expect(runner.usage, equals('''
Metrics installer.

Usage: metrics <command> [arguments]

Global options:
-h, --help    Print this usage information.

Available commands:
  deploy   Creates GCloud and Firebase project and deploy metrics app.

Run "metrics help <command>" for more information about a command.'''));
    });
  });
}
