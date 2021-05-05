// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/prompt/prompter.dart';
import 'package:cli/sentry/cli/sentry_cli.dart';
import 'package:cli/sentry/model/sentry_project.dart';
import 'package:cli/sentry/model/sentry_release.dart';
import 'package:cli/sentry/model/source_map.dart';
import 'package:cli/sentry/service/sentry_service.dart';
import 'package:cli/sentry/strings/sentry_strings.dart';

/// An adapter for the [SentryCli] to implement the [SentryService] interface.
class SentryCliServiceAdapter implements SentryService {
  /// A [SentryCli] class that provides an ability to interact
  /// with the Sentry CLI.
  final SentryCli _sentryCli;

  /// A [Prompter] class this adapter uses to interact with a user.
  final Prompter _prompter;

  /// Creates a new instance of the [SentryCliServiceAdapter]
  /// with the given [SentryCli] and [Prompter].
  ///
  /// Throws an [ArgumentError] if the given [SentryCli] is `null`.
  /// Throws an [ArgumentError] if the given [Prompter] is `null`.
  SentryCliServiceAdapter(
    this._sentryCli,
    this._prompter,
  ) {
    ArgumentError.checkNotNull(_sentryCli, 'sentryCli');
    ArgumentError.checkNotNull(_prompter, 'prompter');
  }

  @override
  Future<void> login() {
    return _sentryCli.login();
  }

  @override
  Future<SentryRelease> createRelease(
    List<SourceMap> sourceMaps,
  ) async {
    final sentryRelease = _promptSentryRelease();

    await _sentryCli.createRelease(sentryRelease);
    await _uploadSourceMaps(sentryRelease, sourceMaps);
    await _sentryCli.finalizeRelease(sentryRelease);

    return sentryRelease;
  }

  @override
  Future<void> version() {
    return _sentryCli.version();
  }

  @override
  String getProjectDsn(SentryProject project) {
    return _prompter.prompt(SentryStrings.enterDsn(
      project.organizationSlug,
      project.projectSlug,
    ));
  }

  /// Prompts the [SentryRelease] from the user.
  SentryRelease _promptSentryRelease() {
    final sentryProject = _promptSentryProject();
    final releaseName = _prompter.prompt(SentryStrings.enterReleaseName);

    return SentryRelease(name: releaseName, project: sentryProject);
  }

  /// Prompts the [SentryProject] from the user.
  SentryProject _promptSentryProject() {
    final organizationSlug = _prompter.prompt(
      SentryStrings.enterOrganizationSlug,
    );
    final projectSlug = _prompter.prompt(SentryStrings.enterProjectSlug(
      organizationSlug,
    ));

    return SentryProject(
      organizationSlug: organizationSlug,
      projectSlug: projectSlug,
    );
  }

  /// Uploads the given [sourceMaps] to the given Sentry [release].
  Future<void> _uploadSourceMaps(
    SentryRelease release,
    List<SourceMap> sourceMaps,
  ) async {
    for (final sourceMap in sourceMaps) {
      await _sentryCli.uploadSourceMaps(release, sourceMap);
    }
  }
}
