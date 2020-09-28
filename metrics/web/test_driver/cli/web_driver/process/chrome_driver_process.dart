import 'dart:io';

import '../../common/process/process_wrapper.dart';
import '../command/chrome_driver_command.dart';

/// A class that represents the chrome driver process.
class ChromeDriverProcess extends ProcessWrapper {
  /// Creates a new instance of the [ChromeDriverProcess]
  /// with the given [process].
  ChromeDriverProcess._(Process process) : super(process);

  /// Starts the chrome driver in a separate process.
  static Future<ChromeDriverProcess> start(
    ChromeDriverCommand args, {
    String workingDir,
  }) async {
    final process = await Process.start(
      ChromeDriverCommand.executableName,
      args.buildArgs(),
      workingDirectory: workingDir,
    );

    return ChromeDriverProcess._(process);
  }
}
