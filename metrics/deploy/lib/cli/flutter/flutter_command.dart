import 'package:process_run/process_run.dart' as cmd;

/// class wrapping up flutter CLI
class FlutterCommand {
  /// Print cli verison.
  Future<void> version() async {
    await cmd.run('flutter', ['--version'], verbose: true);
  }
}
