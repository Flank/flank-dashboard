// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/interfaces/service/info_service.dart';

/// An abstract class for Sentry service that provides methods
/// for working with Sentry.
abstract class SentryService extends InfoService {
  /// Logins into the Sentry.
  Future<void> login();

  /// Creates a new Sentry release.
  Future<void> createRelease(
    String appPath,
    String buildPath,
    String configPath,
  );
}
