// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:process_run/process_run.dart' as cmd;

/// A base class for CLIs that provides common methods for them.
abstract class Cli {
  /// An executable name of this CLI.
  String get name;

  /// Shows the version information of this CLI.
  Future<void> version();

  /// Runs the executable by the [name].
  Future<ProcessResult> run(
    List<String> arguments, {
    bool verbose = true,
    String workingDirectory,
    Stream<List<int>> stdin,
  }) async {
    return cmd.run(
      name,
      arguments,
      verbose: verbose,
      workingDirectory: workingDirectory,
      stdin: stdin,
    );
  }
}
