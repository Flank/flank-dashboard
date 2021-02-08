// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:meta/meta.dart';

/// Base class for the command wrappers.
///
/// Defines the base methods to wrap a command.
abstract class CommandBuilder {
  final List<String> _args = [];

  /// Creates the [List] of args from the [CommandBuilder] class instance.
  List<String> buildArgs() => List.unmodifiable(_args);

  /// Adds the [arg] to the argument list.
  @protected
  @nonVirtual
  void add(String arg) {
    _args.add(arg);
  }

  /// Adds all the arguments from [args] to the argument list.
  @protected
  @nonVirtual
  void addAll(List<String> args) {
    _args.addAll(args);
  }
}
