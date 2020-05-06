import 'package:args/command_runner.dart';
import 'package:ci_integration/cli/logger/logger.dart';

/// An abstract class representing a single CLI [Command].
abstract class CiIntegrationCommand<T> extends Command<T> {
  /// The [Logger] this command should use for messages and errors.
  final Logger logger;

  /// Creates an instance of this command.
  ///
  /// If the [logger] is `null`, throws an [ArgumentError].
  CiIntegrationCommand(this.logger) {
    ArgumentError.checkNotNull(logger, 'logger');
  }

  /// Returns a parsed value of an argument parameter with the
  /// given [argumentName].
  dynamic getArgumentValue(String argumentName) {
    return argResults[argumentName];
  }
}
