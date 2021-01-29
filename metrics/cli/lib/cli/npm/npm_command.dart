import 'package:process_run/process_run.dart' as cmd;
import 'package:process_run/shell_run.dart';

/// A wrapper class for the Npm CLI.
class NpmCommand {
  /// Creates a new instance of the [NpmCommand].
  const NpmCommand();

  /// Installs npm dependencies in the project by the given [workingDir].
  Future<void> install(String workingDir) async {
    await cmd.run(
      'npm',
      ['install'],
      verbose: true,
      workingDirectory: workingDir,
      stdin: sharedStdIn,
    );
  }

  /// Prints CLI version.
  Future<void> version() async {
    await cmd.run('npm', ['--version'], verbose: true, stdin: sharedStdIn);
  }
}
