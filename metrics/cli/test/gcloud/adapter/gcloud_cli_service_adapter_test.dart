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
    const projectId = 'projectId';
    const projectName = 'projectName';
    const region = 'testRegion';
    const enterRegion = GCloudStrings.enterRegionName;
    const acceptTerms = GCloudStrings.acceptTerms;
    const enterProjectName = GCloudStrings.enterProjectName;

    final gcloudCli = _GCloudCliMock();
    final prompter = PrompterMock();
    final gcloudService = GCloudCliServiceAdapter(gcloudCli, prompter);
    final stateError = StateError('test');
    final configureOAuth = GCloudStrings.configureOAuth(projectId);
    final configureOrganization = GCloudStrings.configureProjectOrganization(
      projectId,
    );
    final confirmProjectName = GCloudStrings.confirmProjectName(projectName);

    tearDown(() {
      reset(gcloudCli);
      reset(prompter);
    });

    PostExpectation<String> whenEnterRegionPrompt() {
      return when(prompter.prompt(enterRegion));
    }

    PostExpectation<bool> whenConfirmProjectName({
      String withProjectName = projectName,
    }) {
      when(prompter.prompt(enterProjectName)).thenReturn(withProjectName);

      return when(prompter.promptConfirm(GCloudStrings.confirmProjectName(
        withProjectName,
      )));
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
      ".createProject() prompts the user to enter the name of the GCloud project",
      () async {
        whenEnterRegionPrompt().thenReturn(region);
        whenConfirmProjectName().thenReturn(true);

        await gcloudService.createProject();

        verify(prompter.prompt(enterProjectName)).called(once);
      },
    );

    test(
      ".createProject() throws if prompter throws during the project name prompting",
      () {
        when(prompter.prompt(enterProjectName)).thenThrow(stateError);

        expect(() => gcloudService.createProject(), throwsStateError);
      },
    );

    test(
      ".createProject() prompts the user to confirm the entered name of the GCloud project",
      () async {
        whenEnterRegionPrompt().thenReturn(region);
        whenConfirmProjectName().thenReturn(true);

        await gcloudService.createProject();

        verify(prompter.promptConfirm(confirmProjectName)).called(once);
      },
    );

    test(
      ".createProject() prompts the user to confirm the generated name of the GCloud project if the name is empty",
      () async {
        const emptyName = '';

        whenEnterRegionPrompt().thenReturn(region);
        when(prompter.prompt(enterProjectName)).thenReturn(emptyName);
        when(prompter.promptConfirm(any)).thenReturn(true);

        final projectId = await gcloudService.createProject();

        verify(
          prompter.promptConfirm(GCloudStrings.confirmProjectName(projectId)),
        ).called(once);
      },
    );

    test(
      ".createProject() throws if prompter throws during the project name confirmation prompting",
      () {
        whenConfirmProjectName().thenThrow(stateError);

        expect(() => gcloudService.createProject(), throwsStateError);
      },
    );

    test(
      ".createProject() re-prompts the user to enter the GCloud project name again if the user doesn't agree with the previous name",
      () async {
        const secondName = 'secondName';

        final confirmSecondName = GCloudStrings.confirmProjectName(secondName);

        whenEnterRegionPrompt().thenReturn(region);
        whenConfirmProjectName().thenAnswer((_) {
          whenConfirmProjectName(withProjectName: secondName).thenReturn(true);

          return false;
        });

        await gcloudService.createProject();

        verify(prompter.prompt(enterProjectName)).called(equals(2));
        verify(prompter.promptConfirm(confirmProjectName)).called(once);
        verify(prompter.promptConfirm(confirmSecondName)).called(once);
      },
    );

    test(
      ".createProject() creates the project with the generated project id and project name",
      () async {
        whenEnterRegionPrompt().thenReturn(region);
        whenConfirmProjectName().thenReturn(true);

        final projectId = await gcloudService.createProject();

        verify(gcloudCli.createProject(projectId, projectName)).called(once);
      },
    );

    test(
      ".createProject() throws if GCloud CLI throws during the project creation",
      () {
        whenConfirmProjectName().thenReturn(true);
        when(gcloudCli.createProject(any, any))
            .thenAnswer((_) => Future.error(stateError));

        expect(gcloudService.createProject(), throwsStateError);
      },
    );

    test(
      ".createProject() stops the project creation process if GCloud CLI throws during the project creation",
      () async {
        whenConfirmProjectName().thenReturn(true);
        when(gcloudCli.createProject(any, any))
            .thenAnswer((_) => Future.error(stateError));

        await expectLater(
          gcloudService.createProject(),
          throwsStateError,
        );

        verify(gcloudCli.createProject(any, any)).called(once);
        verify(prompter.prompt(enterProjectName)).called(once);
        verify(prompter.promptConfirm(confirmProjectName)).called(once);

        verifyNoMoreInteractions(gcloudCli);
        verifyNoMoreInteractions(prompter);
      },
    );

    test(
      ".createProject() shows available regions for the created project",
      () async {
        whenConfirmProjectName().thenReturn(true);
        whenEnterRegionPrompt().thenReturn(region);

        final projectId = await gcloudService.createProject();

        verify(gcloudCli.listRegions(projectId)).called(once);
      },
    );

    test(
      ".createProject() throws if GCloud CLI throws during the available regions showing",
      () async {
        whenConfirmProjectName().thenReturn(true);
        when(gcloudCli.listRegions(any))
            .thenAnswer((_) => Future.error(stateError));

        expect(gcloudService.createProject(), throwsStateError);
      },
    );

    test(
      ".createProject() stops the project creation process if GCloud CLI throws during the available regions showing",
      () async {
        whenConfirmProjectName().thenReturn(true);
        when(gcloudCli.listRegions(any))
            .thenAnswer((_) => Future.error(stateError));

        await expectLater(gcloudService.createProject(), throwsStateError);

        verify(gcloudCli.createProject(any, any)).called(once);
        verify(gcloudCli.listRegions(any)).called(once);

        verifyNoMoreInteractions(gcloudCli);
        verifyNoMoreInteractions(prompter);
      },
    );

    test(
      ".createProject() requests the region from the user",
      () async {
        whenConfirmProjectName().thenReturn(true);
        whenEnterRegionPrompt().thenReturn(region);

        await gcloudService.createProject();

        verify(prompter.prompt(enterRegion)).called(once);
      },
    );

    test(
      ".createProject() throws if GCloud CLI throws during the requesting the region from the user",
      () {
        whenConfirmProjectName().thenReturn(true);
        when(prompter.prompt(enterRegion)).thenThrow(stateError);

        expect(gcloudService.createProject(), throwsStateError);
      },
    );

    test(
      ".createProject() stops the project creation process if there is an error during the requesting the region from the user",
      () async {
        whenConfirmProjectName().thenReturn(true);
        when(prompter.prompt(enterRegion)).thenThrow(stateError);

        await expectLater(gcloudService.createProject(), throwsStateError);

        verify(gcloudCli.createProject(any, any)).called(once);
        verify(gcloudCli.listRegions(any)).called(once);
        verify(prompter.prompt(any)).called(once);

        verifyNoMoreInteractions(gcloudCli);
        verifyNoMoreInteractions(prompter);
      },
    );

    test(
      ".createProject() creates the project app with the given region and the generated project id",
      () async {
        whenConfirmProjectName().thenReturn(true);
        whenEnterRegionPrompt().thenReturn(region);

        final projectId = await gcloudService.createProject();

        verify(gcloudCli.createProjectApp(region, projectId)).called(once);
      },
    );

    test(
      ".createProject() throws if GCloud CLI throws during the project app creation",
      () {
        whenConfirmProjectName().thenReturn(true);
        whenEnterRegionPrompt().thenReturn(region);
        when(gcloudCli.createProjectApp(any, any))
            .thenAnswer((_) => Future.error(stateError));

        expect(gcloudService.createProject(), throwsStateError);
      },
    );

    test(
      ".createProject() stops the project creation process if GCloud CLI throws during the project app creation",
      () async {
        whenConfirmProjectName().thenReturn(true);
        whenEnterRegionPrompt().thenReturn(region);
        when(gcloudCli.createProjectApp(any, any))
            .thenAnswer((_) => Future.error(stateError));

        await expectLater(gcloudService.createProject(), throwsStateError);

        verify(gcloudCli.createProject(any, any)).called(once);
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
        whenConfirmProjectName().thenReturn(true);
        whenEnterRegionPrompt().thenReturn(region);

        final projectId = await gcloudService.createProject();

        verify(gcloudCli.enableFirestoreApi(projectId)).called(once);
      },
    );

    test(
      ".createProject() throws if GCloud CLI throws during the Firestore API enabling",
      () {
        whenConfirmProjectName().thenReturn(true);
        whenEnterRegionPrompt().thenReturn(region);
        when(gcloudCli.enableFirestoreApi(any))
            .thenAnswer((_) => Future.error(stateError));

        expect(gcloudService.createProject(), throwsStateError);
      },
    );

    test(
      ".createProject() stops the project creation process if GCloud CLI throws during the Firestore API enabling",
      () async {
        whenConfirmProjectName().thenReturn(true);
        whenEnterRegionPrompt().thenReturn(region);
        when(gcloudCli.enableFirestoreApi(any))
            .thenAnswer((_) => Future.error(stateError));

        await expectLater(gcloudService.createProject(), throwsStateError);

        verify(gcloudCli.createProject(any, any)).called(once);
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
        whenConfirmProjectName().thenReturn(true);
        whenEnterRegionPrompt().thenReturn(region);

        final projectId = await gcloudService.createProject();

        verify(gcloudCli.createDatabase(region, projectId)).called(once);
      },
    );

    test(
      ".createProject() correctly trims the region prompt",
      () async {
        const region = 'region-1   ';
        const expectedRegion = 'region-1';

        whenConfirmProjectName().thenReturn(true);
        whenEnterRegionPrompt().thenReturn(region);

        final projectId = await gcloudService.createProject();

        verify(gcloudCli.createDatabase(expectedRegion, projectId))
            .called(once);
      },
    );

    test(
      ".createProject() throws if GCloud CLI throws during the database creation",
      () {
        whenConfirmProjectName().thenReturn(true);
        whenEnterRegionPrompt().thenReturn(region);
        when(gcloudCli.createDatabase(any, any))
            .thenAnswer((_) => Future.error(stateError));

        expect(gcloudService.createProject(), throwsStateError);
      },
    );

    test(
      ".createProject() returns the identifier of the created project",
      () async {
        whenConfirmProjectName().thenReturn(true);
        whenEnterRegionPrompt().thenReturn(region);

        final projectId = await gcloudService.createProject();

        expect(projectId, isNotNull);
        verify(gcloudCli.createProject(projectId, projectName)).called(once);
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
      ".configureOAuthOrigins() informs the user how to configure OAuth origins",
      () {
        gcloudService.configureOAuthOrigins(projectId);

        verify(prompter.info(configureOAuth)).called(once);
      },
    );

    test(
      ".configureOAuthOrigins() throws if prompter throws during the configuring OAuth origins",
      () {
        when(prompter.info(configureOAuth)).thenThrow(stateError);

        expect(
          () => gcloudService.configureOAuthOrigins(projectId),
          throwsStateError,
        );
      },
    );

    test(
      ".configureProjectOrganization() prompts the user to configure organization for the GCloud project",
      () async {
        gcloudService.configureProjectOrganization(projectId);

        verify(prompter.prompt(configureOrganization)).called(once);
      },
    );

    test(
      ".configureProjectOrganization() throws if prompter throws during the configuring organization",
      () {
        when(prompter.prompt(configureOrganization)).thenThrow(stateError);

        expect(
          () => gcloudService.configureProjectOrganization(projectId),
          throwsStateError,
        );
      },
    );
  });
}

class _GCloudCliMock extends Mock implements GCloudCli {}
