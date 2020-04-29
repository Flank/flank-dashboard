import 'package:ci_integration/command/logger/logger.dart';
/// A stub class for a [Logger] class providing a test implementation.
class LoggerStub extends Logger {
  /// Used to store all error log requests.
  final List<Object> _errorLogs = [];

  /// Used to store all message log requests.
  final List<Object> _messageLogs = [];

  /// Clears all log requests.
  void clearLogs() {
    _errorLogs.clear();
    _messageLogs.clear();
  }

  /// The number of error log requests performed.
  int get errorLogsNumber => _errorLogs.length;

  /// The number of message log requests performed.
  int get messageLogsNumber => _messageLogs.length;

  @override
  void printError(Object error) {
    _errorLogs.add(error);
  }

  @override
  void printMessage(Object message) {
    _messageLogs.add(message);
  }
}
