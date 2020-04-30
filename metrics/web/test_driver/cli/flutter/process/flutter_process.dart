import 'dart:io';

import '../../common/process/process_wrapper.dart';
import '../command/flutter_command.dart';

/// Represents the process of `flutter` command.
class FlutterProcess extends ProcessWrapper {
  FlutterProcess._(Process process) : super(process);

  /// Starts the flutter executable with the given [args] in separate process.
  ///
  /// [workingDir] specifies the directory in which the command will be running.
  /// [environment] is the [Map] of environment variables that will be available for the process.
  static Future<FlutterProcess> start(
    FlutterCommand args, {
    String workingDir,
    Map<String, String> environment,
  }) async {
    final process = await Process.start(
      FlutterCommand.executableName,
      args.buildArgs(),
      workingDirectory: workingDir,
      environment: environment,
    );

    return FlutterProcess._(process);
  }

  /// Kills the flutter process by sending the 'quit' command.
  ///
  /// Flutter process is different from other processes as it spawns
  /// web-server in a separate process.
  /// So regular [Process] kill will kill only Flutter CLI process and
  /// leaving web-server hanging.
  /// For now, we send 'q' command to Flutter CLI to make sure that it
  /// shutdowns properly by killing web-server process as well.
  @override
  bool kill([ProcessSignal signal = ProcessSignal.sigterm]) {
    this.stdin.writeln('q');

    return true;
  }
}
