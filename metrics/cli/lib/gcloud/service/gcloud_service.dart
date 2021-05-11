// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:cli/interfaces/service/info_service.dart';

/// An abstract class for GCloud service that provides methods
/// for working with GCloud.
abstract class GCloudService extends InfoService {
  /// Logins into the GCloud.
  Future<void> login();

  /// Creates a new GCloud project.
  Future<String> createProject();

  /// Accepts the terms of the service.
  FutureOr<void> acceptTermsOfService();

  /// Configures GCloud OAuth Authorized JavaScript origins for
  /// the GCloud project with the given [projectId].
  FutureOr<void> configureOAuthOrigins(String projectId);

  /// Configures the organization for the project with the given [projectId].
  FutureOr<void> configureProjectOrganization(String projectId);
}
