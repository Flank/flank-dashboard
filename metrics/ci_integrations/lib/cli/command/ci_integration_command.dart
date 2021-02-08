// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:args/command_runner.dart';

/// An abstract class representing a single CLI [Command].
abstract class CiIntegrationCommand<T> extends Command<T> {
  /// Returns a parsed value of an argument parameter with the
  /// given [argumentName].
  dynamic getArgumentValue(String argumentName) {
    return argResults[argumentName];
  }
}
