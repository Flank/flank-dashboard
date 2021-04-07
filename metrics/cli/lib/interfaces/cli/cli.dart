// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:cli/common/strings/common_strings.dart';
import 'package:process_run/process_run.dart' as cmd;
import 'package:process_run/shell_run.dart';

/// A base class for CLIs that provides common methods for them.
abstract class Cli {
  /// A name of the executable for this CLI.
  String get executable;

  /// Shows the version information of this CLI.
  Future<void> version();

  /// Starts a process running [executable] in the [workingDirectory]
  /// with the specified [arguments].
  ///
  /// The [arguments] is a specified [List] of arguments passed to
  /// the [executable]. If the [arguments] is `null`, the empty [List] is used.
  /// The [attachOutput] specifies whether print the [executable]'s output
  /// or not. The [attachOutput] default value is `true`.
  /// Use the [workingDirectory] to set the directory from where the [executable]
  /// will run. If the [workingDirectory] is `null`, the [executable] will run
  /// from the current terminal's working directory.
  /// Provide the [stdin] to enable the interaction with the [executable].
  /// If the [stdin] is `null`, the [sharedStdIn] is used.
  ///
  /// Throws a [StateError] if the process execution exit code is not `0`.
  Future<ProcessResult> run(
    List<String> arguments, {
    bool attachOutput = true,
    String workingDirectory,
    Stream<List<int>> stdin,
  }) async {
    final result = await cmd.runExecutableArguments(
      executable,
      arguments ?? [],
      verbose: attachOutput,
      workingDirectory: workingDirectory,
      stdin: stdin ?? sharedStdIn,
    );

    if (result.exitCode == 0) {
      return result;
    }

    throw StateError(CommonStrings.executionWentWrong(executable));
  }
}
