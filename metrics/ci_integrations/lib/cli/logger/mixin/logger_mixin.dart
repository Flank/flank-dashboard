// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/cli/logger/logger.dart';

/// A mixin that provides a [Logger] instance for a mixed classes.
mixin LoggerMixin {
  /// A class-wide [Logger] that is used to log messages.
  Logger get logger => Logger.forClass(runtimeType);
}
