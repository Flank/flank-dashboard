import 'dart:io';

import '../cli/common/logger/process_logger.dart';
import '../cli/common/runner/process_runner.dart';

/// Starts new processes and then manages them.
class ProcessManager {
  final List<Process> _startedProcesses = [];

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

    final runnerFinishedFuture = runner.started;

    _startedProcesses.add(process);

    process.stderrBroadcast.listen((error) => _processErrorHandler(process));

    if (logFileName != null) {
      ProcessLogger.startLogging(process, logFileName);
    }

    await runnerFinishedFuture;

    return process;
  }

  /// Closes the application on process error.
  Future<void> _processErrorHandler(Process process) async {
    exitCode = await process.exitCode;
    dispose();
    exit(exitCode);
  }

  /// Kills the [process].
  void kill(Process process) {
    process.kill();
  }

  /// Kills all started processes.
  void dispose() {
    print("Cleaning...");

    for (final process in _startedProcesses) {
      kill(process);
    }
  }
}
