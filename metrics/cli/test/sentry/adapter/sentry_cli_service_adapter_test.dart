// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/sentry/adapter/sentry_cli_service_adapter.dart';
import 'package:cli/sentry/cli/sentry_cli.dart';
import 'package:cli/sentry/model/sentry_project.dart';
import 'package:cli/sentry/model/sentry_release.dart';
import 'package:cli/sentry/model/source_map.dart';
import 'package:cli/sentry/strings/sentry_strings.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../test_utils/matchers.dart';
import '../../test_utils/prompter_mock.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group('SentryCliServiceAdapter', () {
    const path = 'path';
    const extensions = ['js'];
    const releaseName = 'releaseName';
    const organizationSlug = 'organizationSlug';
    const projectSlug = 'projectSlug';
    const enterOrganizationSlug = SentryStrings.enterOrganizationSlug;
    const enterReleaseName = SentryStrings.enterReleaseName;

    final sentryCli = _SentryCliMock();
    final prompter = PrompterMock();
    final sentryService = SentryCliServiceAdapter(
      sentryCli: sentryCli,
      prompter: prompter,
    );
    final sentryProject = SentryProject(
      organizationSlug: organizationSlug,
      projectSlug: projectSlug,
    );
    final sentryRelease = SentryRelease(
      name: releaseName,
      project: sentryProject,
    );
    final sourceMap = SourceMap(path: path, extensions: extensions);
    final stateError = StateError('test');

    tearDown(() {
      reset(sentryCli);
      reset(prompter);
    });

    String enterProjectSlug() =>
        SentryStrings.enterProjectSlug(organizationSlug);
    String enterDsn() => SentryStrings.enterDsn(organizationSlug, projectSlug);

    PostExpectation<String> whenPromptOrganisationSlug() {
      return when(prompter.prompt(enterOrganizationSlug));
    }

    PostExpectation<String> whenPromptProjectSlug() {
      return when(prompter.prompt(enterProjectSlug()));
    }

    PostExpectation<String> whenPromptReleaseName() {
      return when(prompter.prompt(enterReleaseName));
    }

    void setupPrompts() {
      whenPromptOrganisationSlug().thenReturn(organizationSlug);
      whenPromptProjectSlug().thenReturn(projectSlug);
      whenPromptReleaseName().thenReturn(releaseName);
    }

    void checkNoMoreInteractions() {
      verifyNoMoreInteractions(sentryCli);
      verifyNoMoreInteractions(prompter);
    }

    test(
      "throws an ArgumentError if the given Sentry CLI is null",
      () {
        expect(
          () => SentryCliServiceAdapter(
            sentryCli: null,
            prompter: prompter,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given prompter is null",
      () {
        expect(
          () => SentryCliServiceAdapter(
            sentryCli: sentryCli,
            prompter: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      ".login() logs in to the Sentry CLI",
      () async {
        await sentryService.login();

        verify(sentryCli.login()).called(once);
      },
    );

    test(
      ".login() throws if Sentry CLI throws during the logging",
      () {
        when(sentryCli.login()).thenAnswer((_) => Future.error(stateError));

        expect(sentryService.login(), throwsStateError);
      },
    );

    test(
      ".createRelease() prompts the user to enter the organisation slug",
      () async {
        setupPrompts();

        await sentryService.createRelease([sourceMap]);

        verify(prompter.prompt(enterOrganizationSlug)).called(once);
      },
    );

    test(
      ".createRelease() throws if prompter throws during the organisation slug prompting",
      () {
        whenPromptOrganisationSlug().thenThrow(stateError);
        whenPromptProjectSlug().thenReturn(projectSlug);
        whenPromptReleaseName().thenReturn(releaseName);

        expect(
          sentryService.createRelease([sourceMap]),
          throwsStateError,
        );
      },
    );

    test(
      ".createRelease() stops the release creation process if prompter throws during the organisation slug prompting",
      () async {
        whenPromptOrganisationSlug().thenThrow(stateError);
        whenPromptProjectSlug().thenReturn(projectSlug);
        whenPromptReleaseName().thenReturn(releaseName);

        await expectLater(
          sentryService.createRelease([sourceMap]),
          throwsStateError,
        );

        verify(prompter.prompt(enterOrganizationSlug)).called(once);

        checkNoMoreInteractions();
      },
    );

    test(
      ".createRelease() prompts the user to enter the project slug",
      () async {
        setupPrompts();

        await sentryService.createRelease([sourceMap]);

        verify(prompter.prompt(enterProjectSlug())).called(once);
      },
    );

    test(
      ".createRelease() throws if prompter throws during the project slug prompting",
      () {
        whenPromptOrganisationSlug().thenReturn(organizationSlug);
        whenPromptProjectSlug().thenThrow(stateError);
        whenPromptReleaseName().thenReturn(releaseName);

        expect(
          sentryService.createRelease([sourceMap]),
          throwsStateError,
        );
      },
    );

    test(
      ".createRelease() stops the release creation process if prompter throws during the project slug prompting",
      () async {
        whenPromptOrganisationSlug().thenReturn(organizationSlug);
        whenPromptProjectSlug().thenThrow(stateError);
        whenPromptReleaseName().thenReturn(releaseName);

        await expectLater(
          sentryService.createRelease([sourceMap]),
          throwsStateError,
        );

        verify(prompter.prompt(enterOrganizationSlug)).called(once);
        verify(prompter.prompt(enterProjectSlug())).called(once);

        checkNoMoreInteractions();
      },
    );

    test(
      ".createRelease() prompts the user to enter the release name",
      () async {
        setupPrompts();

        await sentryService.createRelease([sourceMap]);

        verify(prompter.prompt(enterReleaseName)).called(once);
      },
    );

    test(
      ".createRelease() throws if prompter throws during the release name prompting",
      () {
        whenPromptOrganisationSlug().thenReturn(organizationSlug);
        whenPromptProjectSlug().thenReturn(projectSlug);
        whenPromptReleaseName().thenThrow(stateError);

        expect(
          sentryService.createRelease([sourceMap]),
          throwsStateError,
        );
      },
    );

    test(
      ".createRelease() stops the release creation process if prompter throws during the release name prompting",
      () async {
        whenPromptOrganisationSlug().thenReturn(organizationSlug);
        whenPromptProjectSlug().thenReturn(projectSlug);
        whenPromptReleaseName().thenThrow(stateError);

        await expectLater(
          sentryService.createRelease([sourceMap]),
          throwsStateError,
        );

        verify(prompter.prompt(enterOrganizationSlug)).called(once);
        verify(prompter.prompt(enterProjectSlug())).called(once);
        verify(prompter.prompt(enterReleaseName)).called(once);

        checkNoMoreInteractions();
      },
    );

    test(
      ".createRelease() creates the Sentry release with the given release",
      () async {
        setupPrompts();

        await sentryService.createRelease([sourceMap]);

        verify(sentryCli.createRelease(sentryRelease)).called(once);
      },
    );

    test(
      ".createRelease() throws if Sentry CLI throws during the release creation",
      () {
        setupPrompts();
        when(sentryCli.createRelease(any))
            .thenAnswer((_) => Future.error(stateError));

        expect(
          sentryService.createRelease([sourceMap]),
          throwsStateError,
        );
      },
    );

    test(
      ".createRelease() stops the release creation process if Sentry CLI throws during the release creation",
      () async {
        setupPrompts();
        when(sentryCli.createRelease(any))
            .thenAnswer((_) => Future.error(stateError));

        await expectLater(
          sentryService.createRelease([sourceMap]),
          throwsStateError,
        );

        verify(prompter.prompt(enterOrganizationSlug)).called(once);
        verify(prompter.prompt(enterProjectSlug())).called(once);
        verify(prompter.prompt(enterReleaseName)).called(once);
        verify(sentryCli.createRelease(sentryRelease)).called(once);

        checkNoMoreInteractions();
      },
    );

    test(
      ".createRelease() uploads the given source maps to the given release",
      () async {
        setupPrompts();

        await sentryService.createRelease([sourceMap]);

        verify(sentryCli.uploadSourceMaps(sentryRelease, sourceMap))
            .called(once);
      },
    );

    test(
      ".createRelease() throws if Sentry CLI throws during the source maps uploading",
      () {
        setupPrompts();
        when(sentryCli.uploadSourceMaps(any, any))
            .thenAnswer((_) => Future.error(stateError));

        expect(
          sentryService.createRelease([sourceMap]),
          throwsStateError,
        );
      },
    );

    test(
      ".createRelease() stops the release creation process if Sentry CLI throws during the source maps uploading",
      () async {
        setupPrompts();
        when(sentryCli.uploadSourceMaps(any, any))
            .thenAnswer((_) => Future.error(stateError));

        await expectLater(
          sentryService.createRelease([sourceMap]),
          throwsStateError,
        );

        verify(prompter.prompt(enterOrganizationSlug)).called(once);
        verify(prompter.prompt(enterProjectSlug())).called(once);
        verify(prompter.prompt(enterReleaseName)).called(once);
        verify(sentryCli.createRelease(sentryRelease)).called(once);
        verify(sentryCli.uploadSourceMaps(sentryRelease, sourceMap))
            .called(once);

        checkNoMoreInteractions();
      },
    );

    test(
      ".createRelease() finalizes the given release",
      () async {
        setupPrompts();

        await sentryService.createRelease([sourceMap]);

        verify(sentryCli.finalizeRelease(sentryRelease)).called(once);
      },
    );

    test(
      ".createRelease() throws if Sentry CLI throws during the release finalizing",
      () {
        setupPrompts();
        when(sentryCli.finalizeRelease(any))
            .thenAnswer((_) => Future.error(stateError));

        expect(
          sentryService.createRelease([sourceMap]),
          throwsStateError,
        );
      },
    );

    test(
      ".version() shows the version information",
      () async {
        await sentryService.version();

        verify(sentryCli.version()).called(once);
      },
    );

    test(
      ".version() throws if Sentry CLI throws during the version showing",
      () {
        when(sentryCli.version()).thenAnswer((_) => Future.error(stateError));

        expect(sentryService.version(), throwsStateError);
      },
    );

    test(
      ".getSentryDsn() prompts the user to enter the DSN",
      () {
        sentryService.getDsn(sentryProject);

        verify(prompter.prompt(enterDsn())).called(once);
      },
    );

    test(
      ".getSentryDsn() throws throws if prompter throws during the DSN prompting",
      () {
        when(prompter.prompt(enterDsn())).thenThrow(stateError);

        expect(
          () => sentryService.getDsn(sentryProject),
          throwsStateError,
        );
      },
    );
  });
}

class _SentryCliMock extends Mock implements SentryCli {}
