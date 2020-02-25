import 'dart:io';

import '../../common/process/process_wrapper.dart';
import '../command/flutter_command.dart';

/// Represents the process of `flutter` command.
///
/// Wrapper for [Process] to override [kill] method.
class FlutterProcess extends ProcessWrapper {
  FlutterProcess._(Process process) : super(process);

  /// Starts the flutter process with the given [args].
  ///
  /// [workingDir] specifies the directory in which the command will be running.
  static Future<FlutterProcess> start(
    FlutterCommand args, {
    String workingDir,
  }) async {
    final process = await Process.start(
      FlutterCommand.executableName,
      args.buildArgs(),
      workingDirectory: workingDir,
    );

    return FlutterProcess._(process);
  }

  /// Kills the flutter process by sending the 'quit' command.
  ///
  /// We need to send the command instead of terminating the process to be sure
  /// that the application, running on web-server, will be terminated with the process.
  /// In the case of terminating the process, the application still running on
  /// the web-server and holds the port, specified on running.
  @override
  bool kill([ProcessSignal signal = ProcessSignal.sigterm]) {
    this.stdin.writeln('q');

    return true;
  }
}
