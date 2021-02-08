// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:io';

import '../cli/common/logger/process_logger.dart';
import '../cli/common/process/process_wrapper.dart';
import '../cli/common/runner/process_runner.dart';
import '../common/logger/logger.dart';

typedef ProcessErrorHandler = void Function(Process process);

/// Starts new processes and then manages them.
class ProcessManager {
  final List<ProcessWrapper> _startedProcesses = [];
  final ProcessErrorHandler processErrorHandler;

  ProcessManager({this.processErrorHandler});

  /// Runs the process using the [runner], subscribes to logs, and saves
  /// the process to be able to kill it.
  Future<ProcessWrapper> run(
    ProcessRunner runner, {
    String workingDir,
    String logFileName,
  }) async {
    final process = await runner.run(
      workingDir: workingDir,
    );

    process.exitCodeBroadcast.listen((exitCode) {
      if (exitCode != 0) {
        processErrorHandler?.call(process);
      }
    });

    _startedProcesses.add(process);

    if (logFileName != null) {
      ProcessLogger.startLogging(process, logFileName);
    }

    await runner.isAppStarted();

    return process;
  }

  /// Disposes the [process] resources and kills it.
  void kill(ProcessWrapper process) {
    process.dispose();
    process.kill();
    _startedProcesses.remove(process);
  }

  /// Kills all started processes.
  void dispose() {
    Logger.log("Cleaning...");

    for (final process in _startedProcesses) {
      process.dispose();
      process.kill();
    }

    _startedProcesses.clear();
  }
}
