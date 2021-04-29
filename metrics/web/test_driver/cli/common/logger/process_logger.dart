// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import '../../../common/logger/logger.dart';
import '../../../util/file_utils.dart';
import '../process/process_wrapper.dart';

/// Writes the [ProcessWrapper] logs using the [Logger].
class ProcessLogger extends Logger {
  /// Starts listening the [ProcessWrapper.stdoutBroadcast] and the
  /// [ProcessWrapper.stderrBroadcast] and saving the outputs to [logFileName]
  /// file.
  static void startLogging(ProcessWrapper process, String logFileName) {
    final outputStream = process.stdoutBroadcast;
    final errorStream = process.stderrBroadcast;

    final logsFile = FileUtils.createFile(
      logFileName,
      Logger.logsDirectory.path,
    );

    outputStream.listen((data) {
      final String logLine = String.fromCharCodes(data);
      Logger.log(logLine);
      Logger.logToFile(logLine, logsFile);
    });

    errorStream.listen((data) {
      final errorLine = String.fromCharCodes(data);
      Logger.error(errorLine);
      Logger.logToFile(errorLine, logsFile);
    });
  }
}
