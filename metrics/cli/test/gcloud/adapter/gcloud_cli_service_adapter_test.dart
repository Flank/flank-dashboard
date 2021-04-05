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

    final gcloudCli = _GCloudCliMock();
    final prompter = PrompterMock();
    final gcloudService = GCloudCliServiceAdapter(gcloudCli, prompter);
    final stateError = StateError('test');

    tearDown(() {
      reset(gcloudCli);
      reset(prompter);
    });

    PostExpectation<String> whenEnterRegionPrompt() {
      return when(prompter.prompt(GcloudStrings.enterRegionName));
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
      ".createProject() creates the project with the generated project id",
      () async {
        final projectId = await gcloudService.createProject();

        verify(gcloudCli.createProject(projectId)).called(once);
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
      ".createProject() requests the region from the user",
      () async {
        await gcloudService.createProject();

        verify(prompter.prompt(GcloudStrings.enterRegionName)).called(once);
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
      ".createProject() enables Firestore API for the project with the generated project id",
      () async {
        final projectId = await gcloudService.createProject();

        verify(gcloudCli.enableFirestoreApi(projectId)).called(once);
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
      ".login() throws if logging throws",
      () {
        when(gcloudCli.login()).thenAnswer((_) => Future.error(stateError));

        expect(gcloudService.login(), throwsA(isA<StateError>()));
      },
    );

    test(
      ".createProject() doesn't show available regions if creating project throws",
      () {
        when(gcloudCli.createProject(any))
            .thenAnswer((_) => Future.error(stateError));

        expect(gcloudService.createProject(), throwsA(isA<StateError>()));
        verifyNever(gcloudCli.listRegions(any));
      },
    );

    test(
      ".createProject() doesn't request the region from the user if showing available regions throws",
      () {
        when(gcloudCli.listRegions(any))
            .thenAnswer((_) => Future.error(stateError));

        expect(gcloudService.createProject(), throwsA(isA<StateError>()));
        verifyNever(prompter.prompt(GcloudStrings.enterRegionName));
      },
    );

    test(
      ".createProject() doesn't create the project application if requesting the region from the user throws",
      () {
        when(prompter.prompt(GcloudStrings.enterRegionName))
            .thenThrow(stateError);

        expect(gcloudService.createProject(), throwsA(isA<StateError>()));
        verifyNever(gcloudCli.createProjectApp(any, any));
      },
    );

    test(
      ".createProject() doesn't enables Firestore API if creating the project app throws",
      () {
        when(gcloudCli.createProjectApp(any, any))
            .thenAnswer((_) => Future.error(stateError));

        expect(gcloudService.createProject(), throwsA(isA<StateError>()));
        verifyNever(gcloudCli.enableFirestoreApi(any));
      },
    );

    test(
      ".createProject() doesn't create the database if enabling Firestore API throws",
      () {
        when(gcloudCli.enableFirestoreApi(any))
            .thenAnswer((_) => Future.error(stateError));

        expect(gcloudService.createProject(), throwsA(isA<StateError>()));
        verifyNever(gcloudCli.createDatabase(any, any));
      },
    );

    test(
      ".createProject() throws if creating the database throws",
      () {
        when(gcloudCli.createDatabase(any, any))
            .thenAnswer((_) => Future.error(stateError));

        expect(gcloudService.createProject(), throwsA(isA<StateError>()));
      },
    );

    test(
      ".version() throws if showing the version throws",
      () {
        when(gcloudCli.version()).thenAnswer((_) => Future.error(stateError));

        expect(gcloudService.version(), throwsA(isA<StateError>()));
      },
    );
  });
}

class _GCloudCliMock extends Mock implements GCloudCli {}
