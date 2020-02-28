import 'dart:io';

import '../cli/common/logger/process_logger.dart';
import '../cli/common/runner/process_runner.dart';
import '../common/logger/logger.dart';

typedef ProcessErrorHandler = void Function(Process process);

/// Starts new processes and then manages them.
class ProcessManager {
  final List<Process> _startedProcesses = [];
  final ProcessErrorHandler processErrorHandler;

  ProcessManager({this.processErrorHandler});

  /// Runs the process using the [runner], subscribes to logs, and saves
  /// the process to be able to kill it.
  Future<Process> run(
    ProcessRunner runner, {
    String workingDir,
    String logFileName,
  }) async {
    final process = await runner.run(
      workingDir: workingDir,
    );

    _startedProcesses.add(process);

    process.stderrBroadcast.listen(
      (error) => processErrorHandler?.call(process),
    );

    if (logFileName != null) {
      ProcessLogger.startLogging(process, logFileName);
    }

    await runner.isAppStarted();

    return process;
  }

  /// Kills the [process].
  void kill(Process process) {
    process.kill();
  }

  /// Kills all started processes.
  void dispose() {
    Logger.log("Cleaning...");

    for (final process in _startedProcesses) {
      kill(process);
    }
  }
}
