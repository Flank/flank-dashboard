// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:cli/sentry/adapter/sentry_cli_service_adapter.dart';
import 'package:cli/sentry/cli/sentry_cli.dart';
import 'package:cli/sentry/constants/sentry_constants.dart';
import 'package:cli/sentry/model/sentry_project.dart';
import 'package:cli/sentry/strings/sentry_strings.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../test_utils/file_helper_mock.dart';
import '../../test_utils/matchers.dart';
import '../../test_utils/prompter_mock.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group('SentryCliServiceAdapter', () {
    const appPath = 'appPath';
    const buildPath = 'buildPath';
    const configPath = 'configPath';
    const releaseName = 'releaseName';
    const organizationSlug = 'organizationSlug';
    const projectSlug = 'projectSlug';
    const dsn = 'dsn';
    const enterOrganizationSlug = SentryStrings.enterOrganizationSlug;
    const enterReleaseName = SentryStrings.enterReleaseName;

    final sentryCli = _SentryCliMock();
    final prompter = PrompterMock();
    final fileHelper = FileHelperMock();
    final file = _FileMock();
    final sentryService = SentryCliServiceAdapter(
      sentryCli: sentryCli,
      prompter: prompter,
      fileHelper: fileHelper,
    );
    final sentryProject = SentryProject(
      organizationSlug: organizationSlug,
      projectSlug: projectSlug,
    );
    final stateError = StateError('test');
    final environment = <String, dynamic>{
      SentryConstants.dsn: dsn,
      SentryConstants.releaseName: releaseName,
    };

    tearDown(() {
      reset(sentryCli);
      reset(prompter);
      reset(fileHelper);
      reset(file);
    });

    String enterProjectSlug() =>
        SentryStrings.enterProjectSlug(organizationSlug);
    String enterDsn() => SentryStrings.enterDsn(organizationSlug, projectSlug);

    PostExpectation<String> whenAskOrganisationSlug() {
      return when(prompter.prompt(enterOrganizationSlug));
    }

    PostExpectation<String> whenAskProjectSlug() {
      return when(prompter.prompt(enterProjectSlug()));
    }

    PostExpectation<String> whenAskDsn() {
      return when(prompter.prompt(enterDsn()));
    }

    PostExpectation<String> whenAskReleaseName() {
      return when(prompter.prompt(enterReleaseName));
    }

    void setupPrompts() {
      whenAskOrganisationSlug().thenReturn(organizationSlug);
      whenAskProjectSlug().thenReturn(projectSlug);
      whenAskDsn().thenReturn(dsn);
      whenAskReleaseName().thenReturn(releaseName);
    }

    void checkNoMoreInteractions() {
      verifyNoMoreInteractions(sentryCli);
      verifyNoMoreInteractions(prompter);
      verifyNoMoreInteractions(fileHelper);
    }

    test(
      "throws an ArgumentError if the given Sentry CLI is null",
      () {
        expect(
          () => SentryCliServiceAdapter(
            sentryCli: null,
            prompter: prompter,
            fileHelper: fileHelper,
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
            fileHelper: fileHelper,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given file helper is null",
      () {
        expect(
          () => SentryCliServiceAdapter(
            sentryCli: sentryCli,
            prompter: prompter,
            fileHelper: null,
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

        await sentryService.createRelease(appPath, buildPath, configPath);

        verify(prompter.prompt(enterOrganizationSlug)).called(once);
      },
    );

    test(
      ".createRelease() throws if prompter throws during the organisation slug prompting",
      () {
        whenAskOrganisationSlug().thenThrow(stateError);
        whenAskProjectSlug().thenReturn(projectSlug);
        whenAskDsn().thenReturn(dsn);
        whenAskReleaseName().thenReturn(releaseName);

        expect(
          sentryService.createRelease(appPath, buildPath, configPath),
          throwsStateError,
        );
      },
    );

    test(
      ".createRelease() stops the release creation process if prompter throws during the organisation slug prompting",
      () async {
        whenAskOrganisationSlug().thenThrow(stateError);
        whenAskProjectSlug().thenReturn(projectSlug);
        whenAskDsn().thenReturn(dsn);
        whenAskReleaseName().thenReturn(releaseName);

        await expectLater(
          sentryService.createRelease(appPath, buildPath, configPath),
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

        await sentryService.createRelease(appPath, buildPath, configPath);

        verify(prompter.prompt(enterProjectSlug())).called(once);
      },
    );

    test(
      ".createRelease() throws if prompter throws during the project slug prompting",
      () {
        whenAskOrganisationSlug().thenReturn(organizationSlug);
        whenAskProjectSlug().thenThrow(stateError);
        whenAskDsn().thenReturn(dsn);
        whenAskReleaseName().thenReturn(releaseName);

        expect(
          sentryService.createRelease(appPath, buildPath, configPath),
          throwsStateError,
        );
      },
    );

    test(
      ".createRelease() stops the release creation process if prompter throws during the project slug prompting",
      () async {
        whenAskOrganisationSlug().thenReturn(organizationSlug);
        whenAskProjectSlug().thenThrow(stateError);
        whenAskDsn().thenReturn(dsn);
        whenAskReleaseName().thenReturn(releaseName);

        await expectLater(
          sentryService.createRelease(appPath, buildPath, configPath),
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

        await sentryService.createRelease(appPath, buildPath, configPath);

        verify(prompter.prompt(enterReleaseName)).called(once);
      },
    );

    test(
      ".createRelease() throws if prompter throws during the release name prompting",
      () {
        whenAskOrganisationSlug().thenReturn(organizationSlug);
        whenAskProjectSlug().thenReturn(projectSlug);
        whenAskReleaseName().thenThrow(stateError);
        whenAskDsn().thenReturn(dsn);

        expect(
          sentryService.createRelease(appPath, buildPath, configPath),
          throwsStateError,
        );
      },
    );

    test(
      ".createRelease() stops the release creation process if prompter throws during the release name prompting",
      () async {
        whenAskOrganisationSlug().thenReturn(organizationSlug);
        whenAskProjectSlug().thenReturn(projectSlug);
        whenAskReleaseName().thenThrow(stateError);
        whenAskDsn().thenReturn(dsn);

        await expectLater(
          sentryService.createRelease(appPath, buildPath, configPath),
          throwsStateError,
        );

        verify(prompter.prompt(enterOrganizationSlug)).called(once);
        verify(prompter.prompt(enterProjectSlug())).called(once);
        verify(prompter.prompt(enterReleaseName)).called(once);

        checkNoMoreInteractions();
      },
    );

    test(
      ".createRelease() creates the release with the given release name within the given project",
      () async {
        setupPrompts();

        await sentryService.createRelease(appPath, buildPath, configPath);

        verify(sentryCli.createRelease(releaseName, sentryProject))
            .called(once);
      },
    );

    test(
      ".createRelease() throws if Sentry CLI throws during the release creation",
      () {
        setupPrompts();
        when(sentryCli.createRelease(any, any))
            .thenAnswer((_) => Future.error(stateError));

        expect(
          sentryService.createRelease(appPath, buildPath, configPath),
          throwsStateError,
        );
      },
    );

    test(
      ".createRelease() stops the release creation process if Sentry CLI throws during the release creation",
      () async {
        setupPrompts();
        when(sentryCli.createRelease(any, any))
            .thenAnswer((_) => Future.error(stateError));

        await expectLater(
          sentryService.createRelease(appPath, buildPath, configPath),
          throwsStateError,
        );

        verify(prompter.prompt(enterOrganizationSlug)).called(once);
        verify(prompter.prompt(enterProjectSlug())).called(once);
        verify(prompter.prompt(enterReleaseName)).called(once);
        verify(sentryCli.createRelease(releaseName, sentryProject))
            .called(once);

        checkNoMoreInteractions();
      },
    );

    test(
      ".createRelease() uploads source maps",
      () async {
        setupPrompts();

        await sentryService.createRelease(appPath, buildPath, configPath);

        verify(sentryCli.uploadSourceMaps(any, any, sentryProject, releaseName))
            .called(equals(2));
      },
    );

    test(
      ".createRelease() throws if Sentry CLI throws during the source maps uploading",
      () {
        setupPrompts();
        when(sentryCli.uploadSourceMaps(any, any, any, any))
            .thenAnswer((_) => Future.error(stateError));

        expect(
          sentryService.createRelease(appPath, buildPath, configPath),
          throwsStateError,
        );
      },
    );

    test(
      ".createRelease() stops the release creation process if Sentry CLI throws during the source maps uploading",
      () async {
        setupPrompts();
        when(sentryCli.uploadSourceMaps(any, any, any, any))
            .thenAnswer((_) => Future.error(stateError));

        await expectLater(
          sentryService.createRelease(appPath, buildPath, configPath),
          throwsStateError,
        );

        verify(prompter.prompt(enterOrganizationSlug)).called(once);
        verify(prompter.prompt(enterProjectSlug())).called(once);
        verify(prompter.prompt(enterReleaseName)).called(once);
        verify(sentryCli.createRelease(releaseName, sentryProject))
            .called(once);
        verify(sentryCli.uploadSourceMaps(any, any, sentryProject, releaseName))
            .called(once);

        checkNoMoreInteractions();
      },
    );

    test(
      ".createRelease() finalizes release",
      () async {
        setupPrompts();

        await sentryService.createRelease(appPath, buildPath, configPath);

        verify(sentryCli.finalizeRelease(releaseName, sentryProject))
            .called(once);
      },
    );

    test(
      ".createRelease() throws if Sentry CLI throws during the release finalizing",
      () {
        setupPrompts();
        when(sentryCli.finalizeRelease(any, any))
            .thenAnswer((_) => Future.error(stateError));

        expect(
          sentryService.createRelease(appPath, buildPath, configPath),
          throwsStateError,
        );
      },
    );

    test(
      ".createRelease() stops the release creation process if Sentry CLI throws during the release finalizing",
      () async {
        setupPrompts();
        when(sentryCli.finalizeRelease(any, any))
            .thenAnswer((_) => Future.error(stateError));

        await expectLater(
          sentryService.createRelease(appPath, buildPath, configPath),
          throwsStateError,
        );

        verify(prompter.prompt(enterOrganizationSlug)).called(once);
        verify(prompter.prompt(enterProjectSlug())).called(once);
        verify(prompter.prompt(enterReleaseName)).called(once);
        verify(sentryCli.createRelease(releaseName, sentryProject))
            .called(once);
        verify(sentryCli.uploadSourceMaps(any, any, sentryProject, releaseName))
            .called(equals(2));
        verify(sentryCli.finalizeRelease(releaseName, sentryProject))
            .called(once);

        checkNoMoreInteractions();
      },
    );

    test(
      ".createRelease() prompts the user to enter the DSN",
      () async {
        setupPrompts();

        await sentryService.createRelease(appPath, buildPath, configPath);

        verify(prompter.prompt(enterDsn())).called(once);
      },
    );

    test(
      ".createRelease() throws if Sentry CLI throws during the DSN prompting",
      () {
        whenAskOrganisationSlug().thenReturn(organizationSlug);
        whenAskProjectSlug().thenReturn(projectSlug);
        whenAskReleaseName().thenReturn(releaseName);
        whenAskDsn().thenThrow(stateError);

        expect(
          sentryService.createRelease(appPath, buildPath, configPath),
          throwsStateError,
        );
      },
    );

    test(
      ".createRelease() stops the release creation process if Sentry CLI throws during the DSN prompting",
      () async {
        whenAskOrganisationSlug().thenReturn(organizationSlug);
        whenAskProjectSlug().thenReturn(projectSlug);
        whenAskReleaseName().thenReturn(releaseName);
        whenAskDsn().thenThrow(stateError);

        await expectLater(
          sentryService.createRelease(appPath, buildPath, configPath),
          throwsStateError,
        );

        verify(prompter.prompt(enterOrganizationSlug)).called(once);
        verify(prompter.prompt(enterProjectSlug())).called(once);
        verify(prompter.prompt(enterReleaseName)).called(once);
        verify(sentryCli.createRelease(releaseName, sentryProject))
            .called(once);
        verify(sentryCli.uploadSourceMaps(any, any, sentryProject, releaseName))
            .called(equals(2));
        verify(sentryCli.finalizeRelease(releaseName, sentryProject))
            .called(once);
        verify(prompter.prompt(enterDsn())).called(once);

        checkNoMoreInteractions();
      },
    );

    test(
      ".createRelease() gets the Web project config",
      () async {
        setupPrompts();
        when(fileHelper.getFile(any)).thenReturn(file);

        await sentryService.createRelease(appPath, buildPath, configPath);

        verify(fileHelper.getFile(configPath)).called(once);
      },
    );

    test(
      ".createRelease() throws if file helper throws during the web project config getting",
      () {
        setupPrompts();
        when(fileHelper.getFile(any)).thenThrow(stateError);

        expect(
          sentryService.createRelease(appPath, buildPath, configPath),
          throwsStateError,
        );
      },
    );

    test(
      ".createRelease() stops the release creation process if Sentry CLI throws during the web project config getting",
      () async {
        setupPrompts();
        when(fileHelper.getFile(any)).thenThrow(stateError);

        await expectLater(
          sentryService.createRelease(appPath, buildPath, configPath),
          throwsStateError,
        );

        verify(prompter.prompt(enterOrganizationSlug)).called(once);
        verify(prompter.prompt(enterProjectSlug())).called(once);
        verify(prompter.prompt(enterReleaseName)).called(once);
        verify(sentryCli.createRelease(releaseName, sentryProject))
            .called(once);
        verify(sentryCli.uploadSourceMaps(any, any, sentryProject, releaseName))
            .called(equals(2));
        verify(sentryCli.finalizeRelease(releaseName, sentryProject))
            .called(once);
        verify(prompter.prompt(enterDsn())).called(once);
        verify(fileHelper.getFile(configPath)).called(once);

        checkNoMoreInteractions();
      },
    );

    test(
      ".createRelease() updates the Web project config",
      () async {
        setupPrompts();
        when(fileHelper.getFile(any)).thenReturn(file);

        await sentryService.createRelease(appPath, buildPath, configPath);

        verify(fileHelper.replaceEnvironmentVariables(file, environment))
            .called(once);
      },
    );

    test(
      ".createRelease() throws if file helper throws during the web project config updating",
      () {
        setupPrompts();
        when(fileHelper.replaceEnvironmentVariables(any, any))
            .thenThrow(stateError);

        expect(
          sentryService.createRelease(appPath, buildPath, configPath),
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
  });
}

class _SentryCliMock extends Mock implements SentryCli {}

class _FileMock extends Mock implements File {}
