// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:math';

import 'package:cli/gcloud/cli/gcloud_cli.dart';
import 'package:cli/gcloud/service/gcloud_service.dart';
import 'package:cli/prompt/prompter.dart';
import 'package:cli/prompt/strings/prompt_strings.dart';

/// An adapter for the [GCloudCli] to implement the [GCloudService]
/// interface.
class GCloudCliServiceAdapter implements GCloudService {
  /// A [GCloudCli] class that provides an ability to interact
  /// with the GCloud CLI.
  final GCloudCli _gcloudCli;

  /// Creates a new instance of the [GCloudCliServiceAdapter]
  /// with the given [GCloudCli].
  ///
  /// Throws an [AssertionError] if the given [GCloudCli] is `null`.
  GCloudCliServiceAdapter(this._gcloudCli) : assert(_gcloudCli != null);

  @override
  Future<void> login() {
    return _gcloudCli.login();
  }

  @override
  Future<String> createProject() async {
    final projectId = _generateProjectId();

    await _gcloudCli.listRegions();
    final region = Prompter.prompt(PromptStrings.enterRegionName);

    await _gcloudCli.createProject(projectId);
    await _gcloudCli.createProjectApp(region, projectId);
    await _gcloudCli.enableFirestoreApi(projectId);
    await _gcloudCli.createDatabase(region, projectId);

    return projectId;
  }

  @override
  Future<void> version() {
    return _gcloudCli.version();
  }

  /// Generates the project identifier.
  String _generateProjectId() {
    final random = Random();
    final codeUnits = List.generate(5, (index) => random.nextInt(26) + 97);
    final randomString = String.fromCharCodes(codeUnits);
    return 'metrics-$randomString';
  }
}
