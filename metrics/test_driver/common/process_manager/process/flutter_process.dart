import 'dart:io';

import 'process_wrapper.dart';

/// Represents the process of `flutter` command.
///
/// Wrapper for [Process] to override [kill] method.
class FlutterProcess extends ProcessWrapper {
  static const executableName = 'flutter';

  FlutterProcess._(Process process) : super(process);

  static Future<FlutterProcess> start(
    List<String> args, {
    String workingDir,
  }) async {
    final process = await Process.start(
      executableName,
      args,
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
