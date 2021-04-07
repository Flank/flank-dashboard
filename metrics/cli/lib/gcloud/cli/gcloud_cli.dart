// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/interfaces/cli/cli.dart';

/// A class that represents the GCloud [Cli].
class GCloudCli extends Cli {
  @override
  final String executable = 'gcloud';

  /// Logins into the GCloud CLI.
  Future<void> login() {
    return run(['auth', 'login']);
  }

  /// Creates a new GCloud project with the given [projectId].
  Future<void> createProject(String projectId) {
    return run(['projects', 'create', projectId]);
  }

  /// Displays a list of the GCloud application's available regions
  /// for the project with the given [projectId].
  Future<void> listRegions(String projectId) {
    return run(['app', 'regions', 'list', '--project', projectId]);
  }

  /// Creates a project app located in the provided [region]
  /// within the project with the given [projectId].
  Future<void> createProjectApp(String region, String projectId) {
    return run(['app', 'create', '--region', region, '--project', projectId]);
  }

  /// Enables a Firestore API for the GCloud project with the given [projectId].
  Future<void> enableFirestoreApi(String projectId) {
    return run([
      'services',
      'enable',
      'firestore.googleapis.com',
      '--project',
      projectId,
    ]);
  }

  /// Creates a Firestore database located in the provided [region]
  /// within the project with the given [projectId].
  Future<void> createDatabase(String region, String projectId) {
    return run([
      'firestore',
      'databases',
      'create',
      '--region',
      region,
      '--project',
      projectId,
    ]);
  }

  @override
  Future<void> version() async {
    return run(['--version']);
  }
}
