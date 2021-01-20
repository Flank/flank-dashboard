import 'package:process_run/process_run.dart' as cmd;

/// A wrapper class for the Npm CLI.
class NpmCommand {
  /// Installs all npm dependencies in the project by the given [path].
  Future<void> install(String path) async {
    await cmd.run('npm', ['install', path], verbose: true);
  }

  /// Prints CLI version.
  Future<void> version() async {
    await cmd.run('npm', ['--version'], verbose: true);
  }
}
