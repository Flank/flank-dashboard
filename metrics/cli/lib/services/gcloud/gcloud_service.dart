// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:cli/services/common/info_service.dart';
import 'package:cli/services/common/service/model/service_name.dart';

/// An abstract class for GCloud service that provides methods
/// for working with GCloud.
abstract class GCloudService extends InfoService {
  @override
  ServiceName get serviceName => ServiceName.gcloud;

  /// Logins into the GCloud.
  Future<void> login();

  /// Creates a new GCloud project.
  Future<String> createProject();

  /// Adds the Firebase services to the GCloud project with the given
  /// [projectId].
  Future<void> addFirebase(String projectId);

  /// Accepts the terms of the service.
  FutureOr<void> acceptTermsOfService();

  /// Configures GCloud OAuth Authorized JavaScript origins for
  /// the GCloud project with the given [projectId].
  FutureOr<void> configureOAuthOrigins(String projectId);

  /// Configures the organization for the project with the given [projectId].
  FutureOr<void> configureProjectOrganization(String projectId);

  /// Deletes the GCloud project with the given [projectId].
  Future<void> deleteProject(String projectId);
}
