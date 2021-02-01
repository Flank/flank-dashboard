import 'package:ci_integration/cli/logger/logger.dart';

/// A mixin that provides a [Logger] instance for a mixed classes.
mixin LoggerMixin {
  /// A class-wide [Logger] that is used to log messages.
  Logger get logger => Logger.forClass(runtimeType);
}
