import 'package:process_run/process_run.dart' as cmd;

/// A wrapper class for the Flutter CLI.
class FlutterCommand {
  /// Prints CLI version.
  Future<void> version() async {
    await cmd.run('flutter', ['--version'], verbose: true);
  }
}
