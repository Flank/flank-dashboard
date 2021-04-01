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
    final gcloudAdapter = GCloudCliServiceAdapter(gcloudCli, prompter);
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
        await gcloudAdapter.login();

        verify(gcloudCli.login()).called(once);
      },
    );

    test(
      ".createProject() creates the project with the generated project id",
      () async {
        final projectId = await gcloudAdapter.createProject();

        verify(gcloudCli.createProject(projectId)).called(once);
      },
    );

    test(
      ".createProject() creates the project before showing available regions",
      () async {
        final projectId = await gcloudAdapter.createProject();

        verifyInOrder([
          gcloudCli.createProject(projectId),
          gcloudCli.listRegions(projectId),
        ]);
      },
    );

    test(
      ".createProject() shows available regions for the created project",
      () async {
        final projectId = await gcloudAdapter.createProject();

        verify(gcloudCli.listRegions(projectId)).called(once);
      },
    );

    test(
      ".createProject() shows available regions before requesting the region from the user",
      () async {
        final projectId = await gcloudAdapter.createProject();

        verifyInOrder([
          gcloudCli.listRegions(projectId),
          prompter.prompt(GcloudStrings.enterRegionName),
        ]);
      },
    );

    test(
      ".createProject() requests the region from the user",
      () async {
        await gcloudAdapter.createProject();

        verify(prompter.prompt(GcloudStrings.enterRegionName)).called(once);
      },
    );

    test(
      ".createProject() requests the region from the user before creating the project application",
      () async {
        whenEnterRegionPrompt().thenReturn(region);

        final projectId = await gcloudAdapter.createProject();

        verifyInOrder([
          prompter.prompt(GcloudStrings.enterRegionName),
          gcloudCli.createProjectApp(region, projectId),
        ]);
      },
    );

    test(
      ".createProject() creates the project app with the given region and the generated project id",
      () async {
        whenEnterRegionPrompt().thenReturn(region);

        final projectId = await gcloudAdapter.createProject();

        verify(gcloudCli.createProjectApp(region, projectId)).called(once);
      },
    );

    test(
      ".createProject() creates the project app before enabling Firestore API",
      () async {
        whenEnterRegionPrompt().thenReturn(region);

        final projectId = await gcloudAdapter.createProject();

        verifyInOrder([
          gcloudCli.createProjectApp(region, projectId),
          gcloudCli.enableFirestoreApi(projectId),
        ]);
      },
    );

    test(
      ".createProject() enables Firestore API for the project with the generated project id",
      () async {
        final projectId = await gcloudAdapter.createProject();

        verify(gcloudCli.enableFirestoreApi(projectId)).called(once);
      },
    );

    test(
      ".createProject() enables Firestore API before creating the database",
      () async {
        whenEnterRegionPrompt().thenReturn(region);

        final projectId = await gcloudAdapter.createProject();

        verifyInOrder([
          gcloudCli.enableFirestoreApi(projectId),
          gcloudCli.createDatabase(region, projectId),
        ]);
      },
    );

    test(
      ".createProject() creates database with the generated id and the given region",
      () async {
        whenEnterRegionPrompt().thenReturn(region);

        final projectId = await gcloudAdapter.createProject();

        verify(gcloudCli.createDatabase(region, projectId)).called(once);
      },
    );

    test(
      ".createProject() returns the identifier of the created project",
      () async {
        final projectId = await gcloudAdapter.createProject();

        expect(projectId, isNotNull);
        verify(gcloudCli.createProject(projectId)).called(once);
      },
    );

    test(
      ".version() shows the version information",
      () async {
        await gcloudAdapter.version();

        verify(gcloudCli.version()).called(once);
      },
    );

    test(
      ".login() rethrows a StateError if the logging throws it",
      () {
        when(gcloudCli.login()).thenThrow(stateError);

        final actual = expectAsync0(() => gcloudAdapter.login());

        expect(actual, throwsStateError);
      },
    );

    test(
      ".createProject() doesn't show available regions if the creating project throws the StateError",
      () {
        when(gcloudCli.createProject(any)).thenThrow(stateError);

        final actual = expectAsync0(() => gcloudAdapter.createProject());

        expect(actual, throwsStateError);
        verifyNever(gcloudCli.listRegions(any));
      },
    );

    test(
      ".createProject() doesn't request the region from the user if the showing available regions throws the StateError",
      () {
        when(gcloudCli.listRegions(any)).thenThrow(stateError);

        final actual = expectAsync0(() => gcloudAdapter.createProject());

        expect(actual, throwsStateError);
        verifyNever(prompter.prompt(GcloudStrings.enterRegionName));
      },
    );

    test(
      ".createProject() doesn't create the project application if requesting the region from the user throws the StateError",
      () {
        when(prompter.prompt(GcloudStrings.enterRegionName))
            .thenThrow(stateError);

        final actual = expectAsync0(() => gcloudAdapter.createProject());

        expect(actual, throwsStateError);
        verifyNever(gcloudCli.createProjectApp(any, any));
      },
    );

    test(
      ".createProject() doesn't enables Firestore API if creating the project app throws the StateError",
      () {
        when(gcloudCli.createProjectApp(any, any)).thenThrow(stateError);

        final actual = expectAsync0(() => gcloudAdapter.createProject());

        expect(actual, throwsStateError);
        verifyNever(gcloudCli.enableFirestoreApi(any));
      },
    );

    test(
      ".createProject() doesn't create the database if enabling Firestore API throws the StateError",
      () {
        when(gcloudCli.enableFirestoreApi(any)).thenThrow(stateError);

        final actual = expectAsync0(() => gcloudAdapter.createProject());

        expect(actual, throwsStateError);
        verifyNever(gcloudCli.createDatabase(any, any));
      },
    );

    test(
      ".createProject() rethrows the StateError if creating the database throws it",
      () {
        when(gcloudCli.createDatabase(any, any)).thenThrow(stateError);

        final actual = expectAsync0(() => gcloudAdapter.createProject());

        expect(actual, throwsStateError);
      },
    );

    test(
      ".version() rethrows the StateError if showing the version throws it",
      () {
        when(gcloudCli.version()).thenThrow(stateError);

        final actual = expectAsync0(() => gcloudAdapter.version());

        expect(actual, throwsStateError);
      },
    );
  });
}

class _GCloudCliMock extends Mock implements GCloudCli {}
