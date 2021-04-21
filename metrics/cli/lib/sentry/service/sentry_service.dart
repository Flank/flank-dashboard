// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/interfaces/service/info_service.dart';
import 'package:cli/sentry/model/sentry_project.dart';
import 'package:cli/sentry/model/sentry_release.dart';
import 'package:cli/sentry/model/source_map.dart';

/// An abstract class for Sentry service that provides methods
/// for working with Sentry.
abstract class SentryService extends InfoService {
  /// Logins into the Sentry.
  Future<void> login();

  /// Creates a new Sentry release.
  Future<SentryRelease> createRelease(
    List<SourceMap> sourceMaps,
  );

  /// Returns a Sentry DSN.
  String getDsn(SentryProject release);
}
