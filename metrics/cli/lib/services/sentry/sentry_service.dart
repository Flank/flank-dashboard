// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/services/common/info_service.dart';
import 'package:cli/services/sentry/model/sentry_project.dart';
import 'package:cli/services/sentry/model/sentry_release.dart';
import 'package:cli/services/sentry/model/source_map.dart';

/// An abstract class for Sentry service that provides methods
/// for working with Sentry.
abstract class SentryService extends InfoService {
  /// Logins into the Sentry.
  Future<void> login();

  /// Creates a new Sentry release with associated [sourceMaps]
  /// using the [release].
  ///
  /// Authenticates the release creation process using the given
  /// [authToken] if it is not `null`. Otherwise, authenticates using
  /// the global Sentry token.
  Future<void> createRelease(
    SentryRelease release,
    List<SourceMap> sourceMaps, [
    String authToken,
  ]);

  /// Returns a new instance of the [SentryRelease].
  SentryRelease getSentryRelease();

  /// Returns a DSN of the Sentry [project].
  String getProjectDsn(SentryProject project);
}
