import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:process_run/process_run.dart' as cmd;

// class providing doctor command to verify dependencies.
class DoctorCommand extends Command {
  @override
  final name = "doctor";
  @override
  final description = "Check dependencies.";

  DoctorCommand();

  @override
  Future<void> run() async {
    print('Checking firebase-cli version.');
    try {
      await cmd.run('firebase', ['--version'], verbose: true);
    } catch (e) {
      print(e);
      exit(1);
    }
    print('Checking gcloud cli version.');
    try {
      await cmd.run('gcloud', ['--version'], verbose: true);
    } catch (e) {
      print(e);
      exit(1);
    }
    print('Checking flutter version.');
    try {
      await cmd.run('flutter', ['--version'], verbose: true);
    } catch (e) {
      print(e);
      exit(1);
    }
  }
}
