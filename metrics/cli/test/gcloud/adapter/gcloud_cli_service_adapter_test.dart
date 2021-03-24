// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/gcloud/adapter/gcloud_cli_service_adapter.dart';
import 'package:cli/gcloud/cli/gcloud_cli.dart';
import 'package:cli/prompt/prompter.dart';
import 'package:cli/prompt/strings/gcloud_strings.dart';
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
      ".login() logins to the GCloud CLI",
      () async {
        await gcloudAdapter.login();

        verify(gcloudCli.login()).called(once);
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
        ".createProject() creates the project with the generated id before creating the project app",
        () async {
      when(promptWriter.prompt(GcloudStrings.enterRegionName))
          .thenReturn(region);

      final projectId = await gcloudAdapter.createProject();

      verifyInOrder([
        gcloudCli.createProject(projectId),
        gcloudCli.createProjectApp(region, projectId),
      ]);
    });

    test(
      ".createProject() creates the project app with the generated id and the given region before enabling firestore API.",
      () async {
        when(promptWriter.prompt(GcloudStrings.enterRegionName))
            .thenReturn(region);

        final projectId = await gcloudAdapter.createProject();

        verifyInOrder([
          gcloudCli.createProjectApp(region, projectId),
          gcloudCli.enableFirestoreApi(projectId),
        ]);
      },
    );

    test(
      ".createProject() enables firestore API for the project with the generated id before creating the database",
      () async {
        when(promptWriter.prompt(GcloudStrings.enterRegionName))
            .thenReturn(region);

        final projectId = await gcloudAdapter.createProject();

        verifyInOrder([
          gcloudCli.enableFirestoreApi(projectId),
          gcloudCli.createDatabase(region, projectId),
        ]);
      },
    );

    test(
      ".createProject() create database with the generated id and the given region",
      () async {
        when(promptWriter.prompt(GcloudStrings.enterRegionName))
            .thenReturn(region);

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
