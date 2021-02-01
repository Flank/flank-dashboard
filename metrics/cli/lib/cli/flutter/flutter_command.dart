import 'package:process_run/process_run.dart' as cmd;
import 'package:process_run/shell_run.dart';

/// A wrapper class for the Flutter CLI.
class FlutterCommand {
  /// Creates a new instance of the [FlutterCommand].
  const FlutterCommand();

  /// Prints CLI version.
  Future<void> version() async {
    await cmd.run('flutter', ['--version'], verbose: true, stdin: sharedStdIn);
  }

  /// Enables Web support for the Flutter.
  Future<void> enableWeb() async {
    await cmd.run(
      'flutter',
      ['config', '--enable-web'],
      verbose: true,
      stdin: sharedStdIn,
    );
  }

  /// Builds Flutter Web project.
  Future<void> buildWeb(String workingDir) async {
    await cmd.run(
      'flutter',
      ['build', 'web'],
      workingDirectory: workingDir,
      verbose: true,
      stdin: sharedStdIn,
    );
  }
}
