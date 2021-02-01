import 'dart:io';

import 'package:cli/constants/config_constants.dart';
import 'package:cli/deploy/deploy_command.dart';
import 'package:cli/strings/prompt_strings.dart';
import 'package:cli/util/file_helper.dart';
import 'package:cli/util/prompt_util.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../test_util/called_once_verification_result.dart';
import '../test_util/mocks.dart';

void main() {
  group("DeployCommand", () {
    const projectId = 'projectId';
    const region = 'region';
    const firebaseToken = 'token';
    const repoURL = ConfigConstants.repoURL;
    const tempDir = ConfigConstants.tempDir;
    const webPath = ConfigConstants.webPath;
    const firebasePath = ConfigConstants.firebasePath;
    const functionsPath = ConfigConstants.firebaseFunctionsPath;
    final directoryMatcher =
        predicate<Directory>((event) => event.path == tempDir);

    final firebaseMock = FirebaseCommandMock();
    final gcloudMock = GCloudCommandMock();
    final gitMock = GitCommandMock();
    final flutterMock = FlutterCommandMock();
    final npmMock = NpmCommandMock();
    final promptWrapperMock = PromptWrapperMock();
    final fileHelperMock = FileHelperMock();

    final command = DeployCommand(
      firebase: firebaseMock,
      gcloud: gcloudMock,
      git: gitMock,
      flutter: flutterMock,
      npm: npmMock,
      fileHelper: fileHelperMock,
    );

    setUpAll(() {
      PromptUtil.init(promptWrapperMock);
    });

    setUp(() async {
      reset(firebaseMock);
      reset(gcloudMock);
      reset(gitMock);
      reset(flutterMock);
      reset(npmMock);
      reset(promptWrapperMock);
      reset(fileHelperMock);

      when(gcloudMock.addProject()).thenAnswer((_) => Future.value(projectId));
      when(firebaseMock.login()).thenAnswer((_) => Future.value(firebaseToken));
      when(promptWrapperMock.prompt(PromptStrings.selectRegion))
          .thenAnswer((_) => Future.value(region));
      when(promptWrapperMock.promptConfirm(PromptStrings.enableBillingAccount))
          .thenAnswer((_) => Future.value(true));
    });

    test(".name equals to the 'deploy' command name", () {
      final deployCommand = DeployCommand();

      final name = deployCommand.name;

      expect(name, equals('deploy'));
    });

    test(".description is non-empty string with command desctiption", () {
      final deployCommand = DeployCommand();

      final description = deployCommand.description;

      expect(description, isNotEmpty);
    });

    test(".run() logs in Gcloud", () async {
      await command.run();

      verify(gcloudMock.login()).calledOnce();
    });

    test(".run() logs in Firebase", () async {
      await command.run();

      verify(firebaseMock.login()).calledOnce();
    });

    test(".run() clones a repo", () async {
      await command.run();

      verify(gitMock.clone(repoURL, tempDir)).calledOnce();
    });

    test(".run() adds project after the gcloud login", () async {
      await command.run();

      verifyInOrder([
        gcloudMock.login(),
        gcloudMock.addProject(),
      ]);
    });

    test(
      ".run() adds project app after adding a project and selecting a region",
      () async {
        await command.run();

        verifyInOrder([
          gcloudMock.addProject(),
          promptWrapperMock.prompt(PromptStrings.selectRegion),
          gcloudMock.addProjectApp(region, projectId),
        ]);
      },
    );

    test(
      ".run() creates firestore database after adding a project and selecting a region",
      () async {
        await command.run();

        verifyInOrder([
          gcloudMock.addProject(),
          promptWrapperMock.prompt(PromptStrings.selectRegion),
          gcloudMock.createDatabase(region, projectId),
        ]);
      },
    );

    test(
      ".run() adds the firebase after firebase login and adding a project",
      () async {
        await command.run();

        verifyInOrder([
          gcloudMock.addProject(),
          firebaseMock.login(),
          firebaseMock.addFirebase(projectId, firebaseToken),
        ]);
      },
    );

    test(
      ".run() creates web app after adding firebase",
      () async {
        await command.run();

        verifyInOrder([
          firebaseMock.addFirebase(projectId, firebaseToken),
          firebaseMock.createWebApp(projectId, firebaseToken),
        ]);
      },
    );

    test(
      ".run() inits a firebase project in the web folder after adding a project, firebase login and cloning a repo",
      () async {
        await command.run();

        verifyInOrder([
          gcloudMock.addProject(),
          firebaseMock.login(),
          gitMock.clone(repoURL, tempDir),
          firebaseMock.initFirebaseProject(projectId, webPath, firebaseToken),
        ]);
      },
    );

    test(
      ".run() builds web app after initializing a firebase project in the web folder",
      () async {
        await command.run();

        verifyInOrder([
          firebaseMock.initFirebaseProject(projectId, webPath, firebaseToken),
          flutterMock.buildWeb(webPath),
        ]);
      },
    );

    test(
      ".run() clears and applies target after building a project",
      () async {
        await command.run();

        verifyInOrder([
          flutterMock.buildWeb(webPath),
          firebaseMock.clearTarget(webPath, firebaseToken),
          firebaseMock.applyTarget(projectId, webPath, firebaseToken),
        ]);
      },
    );

    test(
      ".run() deploys a project to the firebase hosting after applying a target",
      () async {
        await command.run();

        verifyInOrder([
          firebaseMock.applyTarget(projectId, webPath, firebaseToken),
          firebaseMock.deployHosting(webPath, firebaseToken),
        ]);
      },
    );

    test(
      ".run() inits a firebase project in the firebase folder after adding a project, firebase login and cloning a repo",
      () async {
        await command.run();

        verifyInOrder([
          gcloudMock.addProject(),
          firebaseMock.login(),
          gitMock.clone(repoURL, tempDir),
          firebaseMock.initFirebaseProject(projectId, firebasePath, firebaseToken),
        ]);
      },
    );

    test(
      ".run() installs npm and deploys a firestore configuration after initializing a firebase project in the firebase folder",
      () async {
        await command.run();

        verifyInOrder([
          firebaseMock.initFirebaseProject(projectId, firebasePath, firebaseToken),
          npmMock.install(firebasePath),
          firebaseMock.deployFirestore(firebasePath, firebaseToken),
        ]);
      },
    );

    test(
      ".run() installs npm and deploys functions after proceeding a billing prompt",
      () async {
        const proceed = true;
        const enableBillingAccount = PromptStrings.enableBillingAccount;

        when(promptWrapperMock.promptConfirm(enableBillingAccount))
            .thenAnswer((_) => Future.value(proceed));

        await command.run();

        verifyInOrder([
          promptWrapperMock.promptConfirm(enableBillingAccount),
          npmMock.install(functionsPath),
          firebaseMock.deployFunctions(firebasePath, firebaseToken),
        ]);
      },
    );

    test(
      ".run() does not install npm and deploy functions after canceling a billing prompt",
      () async {
        const proceed = false;
        const enableBillingAccount = PromptStrings.enableBillingAccount;

        when(promptWrapperMock.promptConfirm(enableBillingAccount))
            .thenAnswer((_) => Future.value(proceed));

        await command.run();

        verify(promptWrapperMock.promptConfirm(enableBillingAccount))
            .calledOnce();

        verifyNever(npmMock.install(functionsPath));
        verifyNever(firebaseMock.deployFunctions(firebasePath, firebaseToken));
      },
    );

    test(
      ".run() deletes a temporary folder after deploying firestore configuration, if the billing prompt is cancelled",
      () async {
        const proceed = false;
        const enableBillingAccount = PromptStrings.enableBillingAccount;

        when(promptWrapperMock.promptConfirm(enableBillingAccount))
            .thenAnswer((_) => Future.value(proceed));

        await command.run();

        verifyInOrder(
          [
            firebaseMock.deployFirestore(firebasePath, firebaseToken),
            promptWrapperMock.promptConfirm(enableBillingAccount),
            fileHelperMock.deleteDirectory(argThat(directoryMatcher)),
          ],
        );
      },
    );

    test(
      ".run() deletes a temporary folder after deploying functions if the billing prompt is proceeded",
      () async {
        const proceed = true;
        const enableBillingAccount = PromptStrings.enableBillingAccount;

        when(promptWrapperMock.promptConfirm(enableBillingAccount))
            .thenAnswer((_) => Future.value(proceed));

        await command.run();

        verifyInOrder(
          [
            promptWrapperMock.promptConfirm(enableBillingAccount),
            firebaseMock.deployFunctions(firebasePath, firebaseToken),
            fileHelperMock.deleteDirectory(argThat(directoryMatcher)),
          ],
        );
      },
    );

    test(
      ".run() deletes a temporary folder even if any of the deploy steps throwing an error",
      () async {
        await command.run();

        when(gitMock.clone(repoURL, webPath)).thenThrow(Exception());

        final directoryMatcher =
            predicate<Directory>((event) => event.path == tempDir);

        verify(fileHelperMock.deleteDirectory(argThat(directoryMatcher)))
            .calledOnce();
      },
    );
  });
}

class FileHelperMock extends Mock implements FileHelper {}
