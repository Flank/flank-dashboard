// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:process_run/process_run.dart' as cmd;

/// A wrapper class for the Flutter CLI.
class FlutterCommand {
  /// Prints CLI version.
  Future<void> version() async {
    await cmd.run('flutter', ['--version'], verbose: true);
  }
}
