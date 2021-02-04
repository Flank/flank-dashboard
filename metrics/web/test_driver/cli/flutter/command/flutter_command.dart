// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import '../../../common/model/device.dart';
import '../../common/command/command_builder.dart';

/// Base class for wrappers of the flutter command.
///
/// Contains all common command params for flutter executable.
abstract class FlutterCommand extends CommandBuilder {
  static const executableName = 'flutter';

  /// --verbose
  ///
  /// Noisy logging, including all shell commands executed.
  void verbose() => add('--verbose');

  ///  --device-id
  ///
  ///  Target device id or name (prefixes allowed).
  void device(Device device) => add('--device-id=${device.value}');

  /// --machine
  ///
  /// Outputs the information using JSON.
  void machine() => add('--machine');
}
