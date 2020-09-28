import 'package:args/command_runner.dart';
import 'dart:io';
import 'package:process_run/process_run.dart' as cmd;

class DoctorCommand extends Command {
  final name = "doctor";
  final description = "Check dependencies.";

  DoctorCommand();

  void run() async {
    print('Checking firebase-cli version.');
    try {
      await cmd.run('firebase', ['--version'], verbose: true);
    } catch (e) {
      print(e);
      exit(0);
    }
    print('Checking gcloud cli version.');
    try {
      await cmd.run('gcloud', ['--version'], verbose: true);
    } catch (e) {
      print(e);
      exit(0);
    }
    print('Checking flutter version.');
    try {
      await cmd.run('flutter', ['--version'], verbose: true);
    } catch (e) {
      print(e);
      exit(0);
    }
  }
}
