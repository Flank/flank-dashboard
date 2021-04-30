// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/gcloud/adapter/gcloud_cli_service_adapter.dart';
import 'package:cli/gcloud/cli/gcloud_cli.dart';
import 'package:cli/gcloud/strings/gcloud_strings.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../test_utils/matchers.dart';
import '../../test_utils/prompter_mock.dart';

void main() {
  group('GCloudCliServiceAdapter', () {
    const region = 'testRegion';
    const projectId = 'projectId';
    const enterRegion = GCloudStrings.enterRegionName;
    const acceptTerms = GCloudStrings.acceptTerms;

    final gcloudCli = _GCloudCliMock();
    final prompter = PrompterMock();
    final gcloudService = GCloudCliServiceAdapter(gcloudCli, prompter);
    final stateError = StateError('test');
    final configureOAuth = GCloudStrings.configureOAuth(projectId);

    tearDown(() {
      reset(gcloudCli);
      reset(prompter);
    });

    PostExpectation<String> whenEnterRegionPrompt() {
      return when(prompter.prompt(enterRegion));
    }

    test(
      "throws an ArgumentError if the given GCloud CLI is null",
      () {
        expect(
          () => GCloudCliServiceAdapter(null, prompter),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given prompter is null",
      () {
        expect(
          () => GCloudCliServiceAdapter(gcloudCli, null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".login() logs in to the GCloud CLI",
      () async {
        await gcloudService.login();

        verify(gcloudCli.login()).called(once);
      },
    );

    test(
      ".login() throws if GCloud CLI throws during the logging",
      () {
        when(gcloudCli.login()).thenAnswer((_) => Future.error(stateError));

        expect(gcloudService.login(), throwsStateError);
      },
    );

    test(
      ".createProject() creates the project with the generated project id",
      () async {
        final projectId = await gcloudService.createProject();

        verify(gcloudCli.createProject(projectId)).called(once);
      },
    );

    test(
      ".createProject() throws if GCloud CLI throws during the project creation",
      () {
        when(gcloudCli.createProject(any))
            .thenAnswer((_) => Future.error(stateError));

        expect(gcloudService.createProject(), throwsStateError);
      },
    );

    test(
      ".createProject() stops the project creation process if GCloud CLI throws during the project creation",
      () async {
        when(gcloudCli.createProject(any))
            .thenAnswer((_) => Future.error(stateError));

        await expectLater(
          gcloudService.createProject(),
          throwsStateError,
        );

        verify(gcloudCli.createProject(any)).called(once);

        verifyNoMoreInteractions(gcloudCli);
        verifyNoMoreInteractions(prompter);
      },
    );

    test(
      ".createProject() shows available regions for the created project",
      () async {
        final projectId = await gcloudService.createProject();

        verify(gcloudCli.listRegions(projectId)).called(once);
      },
    );

    test(
      ".createProject() throws if GCloud CLI throws during the available regions showing",
      () async {
        when(gcloudCli.listRegions(any))
            .thenAnswer((_) => Future.error(stateError));

        expect(gcloudService.createProject(), throwsStateError);
      },
    );

    test(
      ".createProject() stops the project creation process if GCloud CLI throws during the available regions showing",
      () async {
        when(gcloudCli.listRegions(any))
            .thenAnswer((_) => Future.error(stateError));

        await expectLater(gcloudService.createProject(), throwsStateError);

        verify(gcloudCli.createProject(any)).called(once);
        verify(gcloudCli.listRegions(any)).called(once);

        verifyNoMoreInteractions(gcloudCli);
        verifyNoMoreInteractions(prompter);
      },
    );

    test(
      ".createProject() requests the region from the user",
      () async {
        await gcloudService.createProject();

        verify(prompter.prompt(enterRegion)).called(once);
      },
    );

    test(
      ".createProject() throws if GCloud CLI throws during the requesting the region from the user",
      () {
        when(prompter.prompt(enterRegion)).thenThrow(stateError);

        expect(gcloudService.createProject(), throwsStateError);
      },
    );

    test(
      ".createProject() stops the project creation process if there is an error during the requesting the region from the user",
      () async {
        when(prompter.prompt(enterRegion)).thenThrow(stateError);

        await expectLater(gcloudService.createProject(), throwsStateError);

        verify(gcloudCli.createProject(any)).called(once);
        verify(gcloudCli.listRegions(any)).called(once);
        verify(prompter.prompt(any)).called(once);

        verifyNoMoreInteractions(gcloudCli);
        verifyNoMoreInteractions(prompter);
      },
    );

    test(
      ".createProject() creates the project app with the given region and the generated project id",
      () async {
        whenEnterRegionPrompt().thenReturn(region);

        final projectId = await gcloudService.createProject();

        verify(gcloudCli.createProjectApp(region, projectId)).called(once);
      },
    );

    test(
      ".createProject() throws if GCloud CLI throws during the project app creation",
      () {
        when(gcloudCli.createProjectApp(any, any))
            .thenAnswer((_) => Future.error(stateError));

        expect(gcloudService.createProject(), throwsStateError);
      },
    );

    test(
      ".createProject() stops the project creation process if GCloud CLI throws during the project app creation",
      () async {
        when(gcloudCli.createProjectApp(any, any))
            .thenAnswer((_) => Future.error(stateError));

        await expectLater(gcloudService.createProject(), throwsStateError);

        verify(gcloudCli.createProject(any)).called(once);
        verify(gcloudCli.listRegions(any)).called(once);
        verify(prompter.prompt(any)).called(once);
        verify(gcloudCli.createProjectApp(any, any)).called(once);

        verifyNoMoreInteractions(gcloudCli);
        verifyNoMoreInteractions(prompter);
      },
    );

    test(
      ".createProject() enables Firestore API for the project with the generated project id",
      () async {
        final projectId = await gcloudService.createProject();

        verify(gcloudCli.enableFirestoreApi(projectId)).called(once);
      },
    );

    test(
      ".createProject() throws if GCloud CLI throws during the Firestore API enabling",
      () {
        when(gcloudCli.enableFirestoreApi(any))
            .thenAnswer((_) => Future.error(stateError));

        expect(gcloudService.createProject(), throwsStateError);
      },
    );

    test(
      ".createProject() stops the project creation process if GCloud CLI throws during the Firestore API enabling",
      () async {
        when(gcloudCli.enableFirestoreApi(any))
            .thenAnswer((_) => Future.error(stateError));

        await expectLater(gcloudService.createProject(), throwsStateError);

        verify(gcloudCli.createProject(any)).called(once);
        verify(gcloudCli.listRegions(any)).called(once);
        verify(prompter.prompt(any)).called(once);
        verify(gcloudCli.createProjectApp(any, any)).called(once);
        verify(gcloudCli.enableFirestoreApi(any)).called(once);

        verifyNoMoreInteractions(gcloudCli);
        verifyNoMoreInteractions(prompter);
      },
    );

    test(
      ".createProject() creates database with the generated id and the given region",
      () async {
        whenEnterRegionPrompt().thenReturn(region);

        final projectId = await gcloudService.createProject();

        verify(gcloudCli.createDatabase(region, projectId)).called(once);
      },
    );

    test(
      ".createProject() throws if GCloud CLI throws during the database creation",
      () {
        when(gcloudCli.createDatabase(any, any))
            .thenAnswer((_) => Future.error(stateError));

        expect(gcloudService.createProject(), throwsStateError);
      },
    );

    test(
      ".createProject() returns the identifier of the created project",
      () async {
        final projectId = await gcloudService.createProject();

        expect(projectId, isNotNull);
        verify(gcloudCli.createProject(projectId)).called(once);
      },
    );

    test(
      ".version() shows the version information",
      () async {
        await gcloudService.version();

        verify(gcloudCli.version()).called(once);
      },
    );

    test(
      ".version() throws if GCloud CLI throws during the version showing",
      () {
        when(gcloudCli.version()).thenAnswer((_) => Future.error(stateError));

        expect(gcloudService.version(), throwsStateError);
      },
    );

    test(
      ".acceptTermsOfService() prompts the user to accept the terms of the GCloud service",
      () async {
        gcloudService.acceptTermsOfService();

        verify(prompter.prompt(acceptTerms)).called(once);
      },
    );

    test(
      ".acceptTermsOfService() throws if prompter throws during the terms prompting",
      () {
        when(prompter.prompt(acceptTerms)).thenThrow(stateError);

        expect(() => gcloudService.acceptTermsOfService(), throwsStateError);
      },
    );

    test(
      ".configureOAuthOrigins() prompts the user to configure OAuth origins",
      () {
        gcloudService.configureOAuthOrigins(projectId);

        verify(prompter.prompt(configureOAuth)).called(once);
      },
    );

    test(
      ".configureOAuthOrigins() throws if prompter throws during the configuring OAuth origins",
      () {
        when(prompter.prompt(configureOAuth)).thenThrow(stateError);

        expect(
          () => gcloudService.configureOAuthOrigins(projectId),
          throwsStateError,
        );
      },
    );
  });
}

class _GCloudCliMock extends Mock implements GCloudCli {}
