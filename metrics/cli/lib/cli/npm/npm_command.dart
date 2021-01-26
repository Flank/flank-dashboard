import 'package:process_run/process_run.dart' as cmd;
import 'package:process_run/shell_run.dart';

/// A wrapper class for the Npm CLI.
class NpmCommand {
  /// Installs npm dependencies in the project by the given [path].
  Future<void> install(String path) async {
    await cmd.run(
      'npm',
      ['install'],
      verbose: true,
      workingDirectory: path,
      stdin: sharedStdIn,
    );
  }

  /// Prints CLI version.
  Future<void> version() async {
    await cmd.run('npm', ['--version'], verbose: true, stdin: sharedStdIn);
  }
}
