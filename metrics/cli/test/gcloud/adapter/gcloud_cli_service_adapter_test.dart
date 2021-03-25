// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/gcloud/adapter/gcloud_cli_service_adapter.dart';
import 'package:cli/gcloud/cli/gcloud_cli.dart';
import 'package:cli/gcloud/strings/gcloud_strings.dart';
import 'package:cli/prompt/prompter.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../test_utils/matchers.dart';
import '../../test_utils/prompt_writer_mock.dart';

void main() {
  group('GCloudCliServiceAdapter', () {
    const region = 'testRegion';

    final gcloudCli = _GCloudCliMock();
    final promptWriter = PromptWriterMock();
    final prompter = Prompter(promptWriter);
    final gcloudAdapter = GCloudCliServiceAdapter(gcloudCli, prompter);

    tearDown(() {
      reset(gcloudCli);
      reset(promptWriter);
    });

    PostExpectation<String> whenEnterRegionPrompt() {
      return when(promptWriter.prompt(GcloudStrings.enterRegionName));
    }

    test(
      "throws an ArgumentError if the given gcloud CLI is null",
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
      ".createProject() shows available regions",
      () async {
        await gcloudAdapter.createProject();

        verify(gcloudCli.listRegions()).called(once);
      },
    );

    test(
      ".createProject() shows available regions before requesting the region from the user",
      () async {
        await gcloudAdapter.createProject();

        verifyInOrder([
          gcloudCli.listRegions(),
          promptWriter.prompt(GcloudStrings.enterRegionName),
        ]);
      },
    );

    test(
      ".createProject() requests the region from the user",
      () async {
        await gcloudAdapter.createProject();

        verify(promptWriter.prompt(GcloudStrings.enterRegionName)).called(once);
      },
    );

    test(
      ".createProject() requests the region from the user before creating the project",
      () async {
        final projectId = await gcloudAdapter.createProject();

        verifyInOrder([
          promptWriter.prompt(GcloudStrings.enterRegionName),
          gcloudCli.createProject(projectId),
        ]);
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
      ".createProject() creates the project before creating the project app",
      () async {
        whenEnterRegionPrompt().thenReturn(region);

        final projectId = await gcloudAdapter.createProject();

        verifyInOrder([
          gcloudCli.createProject(projectId),
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
      ".createProject() creates the project app before enabling firestore API.",
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
      ".createProject() enables firestore API before creating the database",
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
      ".createProject() returns the project id",
      () async {
        final projectId = await gcloudAdapter.createProject();

        expect(projectId, isNotNull);
      },
    );

    test(
      ".version() shows the version information",
      () async {
        await gcloudAdapter.version();

        verify(gcloudCli.version()).called(once);
      },
    );
  });
}

class _GCloudCliMock extends Mock implements GCloudCli {}
