part of command;

/// Base class for wrappers of the flutter command.
///
/// Contains all common command params for flutter executable.
abstract class _FlutterCommand {
  final List<String> _args = [];

  /// --verbose
  ///
  /// Noisy logging, including all shell commands executed.
  void verbose() => _add('--verbose');

  ///  --device-id
  ///
  ///  Target device id or name (prefixes allowed).
  void device(Device device) => _add('--device-id=${device.deviceId}');

  /// --machine
  ///
  /// Outputs the information using JSON
  void machine() => _add('--machine');

  /// Creates the [List] of args from the [RunCommand] class instance
  List<String> buildArgs() => List.unmodifiable(_args);

  void _add(String arg) {
    _args.add(arg);
  }
}
