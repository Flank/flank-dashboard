import 'dart:io';

//import 'package:args/command_runner.dart';
//import 'package:guardian/runner/options/global_options.dart';
//import 'package:guardian/runner/guardian_runner.dart';
import 'package:guardian/utils/junit_xml/junit_xml.dart';

Future<void> main(List<String> arguments) async {
//  final globalOptions = GlobalOptions();
//  final runner = GuardianRunner();
//
//  try {
//    await runner.run(arguments);
//  } catch (error, stackTrace) {
//    if (error is UsageException) {
//      stdout.writeln(error);
//    } else {
//      stdout.writeln(error);
//    }
//
//    if (globalOptions.enableStackTrace ?? false) {
//      stdout.writeln(stackTrace);
//    }
//    exit(1);
//  }

  final file = File('test1.xml');
  final parser = JUnitXmlParser();
  parser.parse(file.readAsStringSync());
}
