// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:cli/gcloud/cli/gcloud_cli.dart';
import 'package:cli/gcloud/service/gcloud_service.dart';
import 'package:cli/gcloud/strings/gcloud_strings.dart';
import 'package:cli/prompt/prompter.dart';
import 'package:random_string/random_string.dart';

/// An adapter for the [GCloudCli] to implement the [GCloudService] interface.
class GCloudCliServiceAdapter implements GCloudService {
  /// A [GCloudCli] class that provides an ability to interact
  /// with the GCloud CLI.
  final GCloudCli _gcloudCli;

  /// A [Prompter] class this adapter uses to interact with a user.
  final Prompter _prompter;

  /// Creates a new instance of the [GCloudCliServiceAdapter]
  /// with the given [GCloudCli].
  ///
  /// Throws an [ArgumentError] if the given [GCloudCli] is `null`.
  /// Throws an [ArgumentError] if the given [Prompter] is `null`.
  GCloudCliServiceAdapter(this._gcloudCli, this._prompter) {
    ArgumentError.checkNotNull(_gcloudCli, 'gcloudCli');
    ArgumentError.checkNotNull(_prompter, 'prompter');
  }

  @override
  Future<void> login() {
    return _gcloudCli.login();
  }

  @override
  Future<String> createProject() async {
    final projectId = _generateProjectId();

    await _gcloudCli.createProject(projectId);

    await _gcloudCli.listRegions(projectId);
    final regionPrompt = _prompter.prompt(GCloudStrings.enterRegionName);
    final region = regionPrompt.trim();

    await _gcloudCli.createProjectApp(region, projectId);
    await _gcloudCli.enableFirestoreApi(projectId);
    await _gcloudCli.createDatabase(region, projectId);

    return projectId;
  }

  @override
  Future<void> version() {
    return _gcloudCli.version();
  }

  @override
  void acceptTermsOfService() {
    _prompter.prompt(GCloudStrings.acceptTerms);
  }

  @override
  void configureOAuthOrigins(String projectId) {
    _prompter.info(GCloudStrings.configureOAuth(projectId));
  }

  /// Generates the project identifier.
  String _generateProjectId() {
    final randomString = randomAlphaNumeric(5).toLowerCase();
    return 'metrics-$randomString';
  }

  @override
  FutureOr<void> configureProjectOrganization(String projectId) {
    _prompter.prompt(GCloudStrings.configureProjectOrganization(projectId));
  }
}
