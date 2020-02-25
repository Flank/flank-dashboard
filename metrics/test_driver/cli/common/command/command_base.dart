import 'package:meta/meta.dart';

/// Base class for the command wrappers.
///
/// Defines the base methods to wrap a command.
abstract class CommandBase {
  final List<String> _args = [];

  /// Creates the [List] of args from the [CommandBase] class instance
  List<String> buildArgs() => List.unmodifiable(_args);

  /// Adds the [arg] to argument list.
  @protected
  void add(String arg) {
    _args.add(arg);
  }

  /// Adds all the arguments from [args] to the [_args].
  @protected
  void addAll(List<String> args) {
    _args.addAll(args);
  }
}
