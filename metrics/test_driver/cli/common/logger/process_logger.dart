import '../../../common/logger/logger.dart';
import '../../../util/file_utils.dart';
import '../process/process_wrapper.dart';

/// Writes the [ProcessWrapper] logs to file and [stdout].
class ProcessLogger extends Logger {
  /// Starts listening the [outputStream] and the [errorStream] and saving
  /// the outputs to [logFileName] file.
  ///
  /// If is not in [_quiet] mode, writes the outputs into [stdout] and [stderr].
  static void startLogging(ProcessWrapper process, String logFileName) {
    final outputStream = process.stdoutBroadcast;
    final errorStream = process.stderrBroadcast;

    final logsFile = FileUtils.createLogFile(
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
