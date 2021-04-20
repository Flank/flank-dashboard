// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/helper/file_helper.dart';
import 'package:cli/prompt/prompter.dart';
import 'package:cli/sentry/cli/sentry_cli.dart';
import 'package:cli/sentry/constants/sentry_constants.dart';
import 'package:cli/sentry/model/sentry_project.dart';
import 'package:cli/sentry/service/sentry_service.dart';
import 'package:cli/sentry/strings/sentry_strings.dart';

/// An adapter for the [SentryCli] to implement the [SentryService] interface.
class SentryCliServiceAdapter implements SentryService {
  /// A [SentryCli] class that provides an ability to interact
  /// with the Sentry CLI.
  final SentryCli _sentryCli;

  /// A [Prompter] class this adapter uses to interact with a user.
  final Prompter _prompter;

  /// A [FileHelper] class this adapter uses to work with file system.
  final FileHelper _fileHelper;

  /// Creates a new instance of the [SentryCliServiceAdapter]
  /// with the given [sentryCli], [prompter], and [fileHelper].
  ///
  /// Throws an [ArgumentError] if the given [sentryCli] is `null`.
  /// Throws an [ArgumentError] if the given [prompter] is `null`.
  /// Throws an [ArgumentError] if the given [fileHelper] is `null`.
  SentryCliServiceAdapter({
    SentryCli sentryCli,
    Prompter prompter,
    FileHelper fileHelper,
  })  : _sentryCli = sentryCli,
        _prompter = prompter,
        _fileHelper = fileHelper {
    ArgumentError.checkNotNull(_sentryCli, 'sentryCli');
    ArgumentError.checkNotNull(_prompter, 'prompter');
    ArgumentError.checkNotNull(_fileHelper, 'fileHelper');
  }

  @override
  Future<void> login() {
    return _sentryCli.login();
  }

  @override
  Future<void> createRelease(
    String appPath,
    String buildPath,
    String configPath,
  ) async {
    final sentryProject = _getSentryProject();
    final releaseName = _prompter.prompt(SentryStrings.enterReleaseName);

    await _sentryCli.createRelease(releaseName, sentryProject);
    await _uploadSourceMaps(appPath, buildPath, sentryProject, releaseName);
    await _sentryCli.finalizeRelease(releaseName, sentryProject);
    _updateConfig(sentryProject, configPath, releaseName);
  }

  @override
  Future<void> version() {
    return _sentryCli.version();
  }

  /// Prompts the user and returns a new instance of the [SentryProject].
  SentryProject _getSentryProject() {
    final organizationSlug =
        _prompter.prompt(SentryStrings.enterOrganizationSlug);
    final projectSlug = _prompter.prompt(SentryStrings.enterProjectSlug(
      organizationSlug,
    ));

    return SentryProject(
      organizationSlug: organizationSlug,
      projectSlug: projectSlug,
    );
  }

  /// Uploads the source maps to the Sentry project.
  Future<void> _uploadSourceMaps(
    String appPath,
    String buildPath,
    SentryProject sentryProject,
    String releaseName,
  ) async {
    await _sentryCli.uploadSourceMaps(
      appPath,
      ['dart'],
      sentryProject,
      releaseName,
    );
    await _sentryCli.uploadSourceMaps(
      buildPath,
      ['map', 'js'],
      sentryProject,
      releaseName,
    );
  }

  /// Updates the Web project config.
  void _updateConfig(
    SentryProject sentryProject,
    String configPath,
    String releaseName,
  ) {
    final dsn = _prompter.prompt(SentryStrings.enterDsn(
      sentryProject.organizationSlug,
      sentryProject.projectSlug,
    ));
    final environment = <String, dynamic>{
      SentryConstants.dsn: dsn,
      SentryConstants.releaseName: releaseName,
    };
    final config = _fileHelper.getFile(configPath);

    _fileHelper.replaceEnvironmentVariables(config, environment);
  }
}
