import 'package:args/command_runner.dart';

/// An abstract class representing a single CLI [Command].
abstract class CiIntegrationCommand<T> extends Command<T> {
  /// Returns a parsed value of an argument parameter with the
  /// given [argumentName].
  dynamic getArgumentValue(String argumentName) {
    return argResults[argumentName];
  }
}
