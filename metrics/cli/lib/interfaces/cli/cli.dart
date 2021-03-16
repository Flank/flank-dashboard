// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:process_run/process_run.dart' as cmd;

/// A base class for CLIs that provides common methods for them.
abstract class Cli {
  /// A name of the executable for this CLI.
  String get executable;

  /// Shows the version information of this CLI.
  Future<void> version();

  /// Starts a process running [executable] in the [workingDirectory]
  /// with the specified [arguments].
  ///
  /// Provide the [stdin] to enable the interaction with the [executable].
  /// The [attachOutput] specifies whether print
  /// the [executable]'s output or not.
  ///
  /// The [attachOutput] default value is `true`.
  /// If the [workingDirectory] is `null`, the [executable] will run from
  /// the current terminal's working directory.
  ///
  /// The [arguments] must not be `null`.
  Future<ProcessResult> run(
    List<String> arguments, {
    bool attachOutput = true,
    String workingDirectory,
    Stream<List<int>> stdin,
  }) async {
    return cmd.run(
      executable,
      arguments,
      verbose: attachOutput,
      workingDirectory: workingDirectory,
      stdin: stdin,
    );
  }
}
