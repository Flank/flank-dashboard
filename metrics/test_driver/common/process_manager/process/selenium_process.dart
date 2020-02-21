import 'dart:io';

import 'process_wrapper.dart';

/// Represents the selenium server process.
class SeleniumProcess extends ProcessWrapper {
  static const executableName = 'java';

  SeleniumProcess._(Process process) : super(process);

  static Future<SeleniumProcess> start(
    List<String> args, {
    String workingDir,
  }) async {
    final process = await Process.start(
      executableName,
      args,
      workingDirectory: workingDir,
    );

    return SeleniumProcess._(process);
  }
}
