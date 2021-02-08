// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:meta/meta.dart';

import '../../../common/logger/logger.dart';
import '../process/process_wrapper.dart';

/// Base class for all process runners.
///
/// Describes the way to run the command.
abstract class ProcessRunner {
  /// Runs the command in separate process.
  @mustCallSuper
  Future<ProcessWrapper> run({String workingDir}) async {
    Logger.log("$executableName ${args.join(" ")}\n");
    return null;
  }

  /// Completes when the application is fully started.
  Future<void> isAppStarted();

  /// The name of the executable.
  String get executableName;

  /// The list of arguments to run the executable.
  List<String> get args;
}
