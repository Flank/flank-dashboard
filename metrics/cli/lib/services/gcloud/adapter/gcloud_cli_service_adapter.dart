// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:cli/prompter/prompter.dart';
import 'package:cli/services/gcloud/cli/gcloud_cli.dart';
import 'package:cli/services/gcloud/gcloud_service.dart';
import 'package:cli/services/gcloud/strings/gcloud_strings.dart';
import 'package:random_string/random_string.dart';

/// An adapter for the [GCloudCli] to implement the [GCloudService]
/// abstract methods.
class GCloudCliServiceAdapter extends GCloudService {
  /// A [GCloudCli] class that provides an ability to interact
  /// with the GCloud CLI.
  final GCloudCli _gcloudCli;

  /// A [Prompter] class this adapter uses to interact with a user.
  final Prompter _prompter;

  /// An [AbstractRandomProvider] class uses to generate the [double] values.
  final AbstractRandomProvider _randomProvider;

  /// Creates a new instance of the [GCloudCliServiceAdapter]
  /// with the given [GCloudCli].
  ///
  /// If the [randomProvider] is `null`, the [DefaultRandomProvider] is used.
  ///
  /// Throws an [ArgumentError] if the given [GCloudCli] is `null`.
  /// Throws an [ArgumentError] if the given [Prompter] is `null`.
  GCloudCliServiceAdapter(
    this._gcloudCli,
    this._prompter, [
    AbstractRandomProvider randomProvider,
  ]) : _randomProvider = randomProvider ?? const DefaultRandomProvider() {
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
    final projectName = _promptProjectName(projectId);

    await _gcloudCli.createProject(projectId, projectName);

    return projectId;
  }

  @override
  Future<void> addFirebase(String projectId) async {
    await _gcloudCli.listRegions(projectId);

    final regionPrompt = _prompter.prompt(GCloudStrings.enterRegionName);
    final region = regionPrompt.trim();
    await _gcloudCli.createProjectApp(region, projectId);

    await _gcloudCli.enableFirestoreApi(projectId);

    await _gcloudCli.createDatabase(region, projectId);
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
    final randomString = randomAlphaNumeric(5, provider: _randomProvider);

    return 'metrics-$randomString'.toLowerCase();
  }

  /// Prompts the GCloud project name.
  ///
  /// Uses the [projectId] as the project's name
  /// if the user doesn't specify the name.
  String _promptProjectName(String projectId) {
    bool projectNameConfirmed = false;
    String projectName;

    while (!projectNameConfirmed) {
      final userProjectName = _prompter.prompt(
        GCloudStrings.enterProjectName(projectId),
      );
      final trimmedProjectName = userProjectName.trim();

      projectName = trimmedProjectName.isEmpty ? projectId : trimmedProjectName;
      projectNameConfirmed = _prompter.promptConfirm(
        GCloudStrings.confirmProjectName(projectName),
      );
    }

    return projectName;
  }

  @override
  FutureOr<void> configureProjectOrganization(String projectId) {
    _prompter.prompt(GCloudStrings.configureProjectOrganization(projectId));
  }

  @override
  Future<void> deleteProject(String projectId) {
    return _gcloudCli.deleteProject(projectId);
  }
}
