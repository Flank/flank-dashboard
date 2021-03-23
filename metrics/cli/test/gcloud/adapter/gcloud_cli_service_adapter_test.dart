// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/gcloud/adapter/gcloud_cli_service_adapter.dart';
import 'package:cli/gcloud/cli/gcloud_cli.dart';
import 'package:cli/prompt/prompter.dart';
import 'package:cli/prompt/strings/prompt_strings.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../test_utils/matchers.dart';
import '../../test_utils/prompt_writer_mock.dart';

void main() {
  group('GCloudCliServiceAdapter', () {
    const region = 'testRegion';

    final gcloudCli = _GCloudCliMock();
    final promptWriter = PromptWriterMock();

    final gcloudCliServiceAdapter = GCloudCliServiceAdapter(gcloudCli);
    Prompter.initialize(promptWriter);

    setUp(() {
      when(promptWriter.prompt(PromptStrings.enterRegionName))
          .thenReturn(region);
    });

    tearDown(() {
      reset(gcloudCli);
      reset(promptWriter);
    });

    test(
      "throws an AssertionError if the given flutter CLI is null",
      () {
        expect(() => GCloudCliServiceAdapter(null), throwsAssertionError);
      },
    );

    test(
      ".login() logins to the GCloud CLI",
      () async {
        await gcloudCliServiceAdapter.login();

        verify(gcloudCli.login()).called(once);
      },
    );

    test(
      ".createProject() generates project id",
      () async {
        final projectId = await gcloudCliServiceAdapter.createProject();

        expect(projectId, isNotNull);
      },
    );

    test(
      ".createProject() shows available regions",
      () async {
        await gcloudCliServiceAdapter.createProject();

        verify(gcloudCli.listRegions()).called(once);
      },
    );

    test(
      ".createProject() requests the region from the user",
      () async {
        await gcloudCliServiceAdapter.createProject();

        verify(promptWriter.prompt(PromptStrings.enterRegionName)).called(once);
      },
    );

    test(
      ".createProject() creates the project with the generated project id",
      () async {
        final projectId = await gcloudCliServiceAdapter.createProject();

        verify(gcloudCli.createProject(projectId)).called(once);
      },
    );

    test(
      ".createProject() creates the project app with the given region and project id",
      () async {
        final projectId = await gcloudCliServiceAdapter.createProject();

        verify(gcloudCli.createProjectApp(region, projectId)).called(once);
      },
    );

    test(
      ".createProject() enables Firestore API for the project with given project id",
      () async {
        final projectId = await gcloudCliServiceAdapter.createProject();

        verify(gcloudCli.enableFirestoreApi(projectId)).called(once);
      },
    );

    test(
      ".createProject() create database with the given region and project id",
      () async {
        final projectId = await gcloudCliServiceAdapter.createProject();

        verify(gcloudCli.createDatabase(region, projectId)).called(once);
      },
    );

    test(
      ".createProject() shows available regions before requesting the region from the user",
      () async {
        await gcloudCliServiceAdapter.createProject();

        verifyInOrder([
          gcloudCli.listRegions(),
          promptWriter.prompt(PromptStrings.enterRegionName),
        ]);
      },
    );

    test(
      ".createProject() requests the region from the user before creating the project app",
      () async {
        final projectId = await gcloudCliServiceAdapter.createProject();

        verifyInOrder([
          promptWriter.prompt(PromptStrings.enterRegionName),
          gcloudCli.createProjectApp(region, projectId),
        ]);
      },
    );

    test(
      ".createProject() requests the region from the user before creating the database",
      () async {
        final projectId = await gcloudCliServiceAdapter.createProject();

        verifyInOrder([
          promptWriter.prompt(PromptStrings.enterRegionName),
          gcloudCli.createDatabase(region, projectId),
        ]);
      },
    );

    test(".createProject() creates the project before creating the project app",
        () async {
      final projectId = await gcloudCliServiceAdapter.createProject();

      verifyInOrder([
        gcloudCli.createProject(projectId),
        gcloudCli.createProjectApp(region, projectId),
      ]);
    });

    test(
      ".createProject() creates the project before creating the database",
      () async {
        final projectId = await gcloudCliServiceAdapter.createProject();

        verifyInOrder([
          gcloudCli.createProject(projectId),
          gcloudCli.createDatabase(region, projectId),
        ]);
      },
    );

    test(
      ".createProject() enables firestore API before creating the database",
      () async {
        final projectId = await gcloudCliServiceAdapter.createProject();
        verifyInOrder([
          gcloudCli.enableFirestoreApi(projectId),
          gcloudCli.createDatabase(region, projectId),
        ]);
      },
    );

    test(
      ".version() shows the version information",
      () async {
        await gcloudCliServiceAdapter.version();

        verify(gcloudCli.version()).called(once);
      },
    );
  });
}

class _GCloudCliMock extends Mock implements GCloudCli {}
