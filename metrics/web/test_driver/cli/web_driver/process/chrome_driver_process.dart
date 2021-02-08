// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:process_run/which.dart';

import '../../common/process/process_wrapper.dart';
import '../command/chrome_driver_command.dart';

/// A class that represents the chrome driver process.
class ChromeDriverProcess extends ProcessWrapper {
  /// Creates a new instance of the [ChromeDriverProcess]
  /// with the given [process].
  ChromeDriverProcess._(Process process) : super(process);

  /// Starts the chrome driver in a separate process.
  ///
  /// If there any global-accessible chromedriver - uses this executable,
  /// otherwise uses the executable from the given [workingDir].
  static Future<ChromeDriverProcess> start(
    ChromeDriverCommand args, {
    String workingDir,
  }) async {
    String globalChromedriverDir;
    final chromedriver = whichSync('chromedriver');

    if (chromedriver != null) {
      final chromeDriverFile = File(chromedriver);
      globalChromedriverDir = chromeDriverFile.parent.path;
    }

    final process = await Process.start(
      ChromeDriverCommand.executableName,
      args.buildArgs(),
      workingDirectory: globalChromedriverDir ?? workingDir,
    );

    return ChromeDriverProcess._(process);
  }
}
