// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:args/command_runner.dart';
import 'package:deploy/doctor/doctor_command.dart';
import 'package:test/test.dart';

void main() {
  CommandRunner<dynamic> runner;
  const _defaultUsage = '''
Usage: metrics <command> [arguments]

Global options:
-h, --help    Print this usage information.

Available commands:
  help   Display help information for metrics.

Run "metrics help <command>" for more information about a command.''';
  group("DoctorCommand", () {
    setUpAll(() {
      runner = CommandRunner('metrics', 'Metrics installer.');
    });
    test(
      ".invocation has a sane default",
      () {
        expect(runner.invocation, equals('metrics <command> [arguments]'));
      },
    );
    test('returns the usage string', () {
      expect(runner.usage, equals('''
Metrics installer.

$_defaultUsage'''));
    });
    test("contains custom commands", () {
      runner.addCommand(DoctorCommand());
      expect(runner.usage, equals('''
Metrics installer.

Usage: metrics <command> [arguments]

Global options:
-h, --help    Print this usage information.

Available commands:
  doctor   Check dependencies.

Run "metrics help <command>" for more information about a command.'''));
    });
  });
}
