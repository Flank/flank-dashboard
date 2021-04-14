// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/firebase/adapter/firebase_cli_service_adapter.dart';
import 'package:cli/firebase/cli/firebase_cli.dart';
import 'package:cli/firebase/constants/firebase_constants.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../test_utils/matchers.dart';
import '../../test_utils/prompter_mock.dart';

void main() {
  group('FirebaseCliServiceAdapter', () {
    const projectId = 'projectId';
    const workingDirectory = 'workingDirectory';
    const target = FirebaseConstants.target;

    final firebaseCli = _FirebaseCliMock();
    final prompter = PrompterMock();
    final firebaseService = FirebaseCliServiceAdapter(firebaseCli, prompter);
    final stateError = StateError('test');

    tearDown(() {
      reset(firebaseCli);
      reset(prompter);
    });

    test("throws an ArgumentError if the given Firebase CLI is null", () {
      expect(
        () => FirebaseCliServiceAdapter(null, prompter),
        throwsArgumentError,
      );
    });

    test("throws an ArgumentError if the given prompter is null", () {
      expect(
        () => FirebaseCliServiceAdapter(firebaseCli, null),
        throwsArgumentError,
      );
    });

    test(".login() logs in to the Firebase CLI", () async {
      await firebaseService.login();

      verify(firebaseCli.login()).called(once);
    });

    test(
      ".addProject() adds the Firebase capabilities to the Gcloud project with the given project id",
      () async {
        await firebaseService.addProject(projectId);

        verify(firebaseCli.addFirebase(projectId)).called(once);
      },
    );

    test(
      ".addProject() creates the web app with the given name within the project with the given projectId",
      () async {
        await firebaseService.addProject(projectId);

        verify(firebaseCli.createWebApp(projectId, projectId)).called(once);
      },
    );

    test(
      ".deployFirebase() sets the default Firebase project with the given project id in the given working directory",
      () async {
        await firebaseService.deployFirebase(projectId, workingDirectory);

        verify(firebaseCli.setFirebaseProject(projectId, workingDirectory))
            .called(once);
      },
    );

    test(
      ".deployFirebase() deploys the Firestore from the given working directory",
      () async {
        await firebaseService.deployFirebase(projectId, workingDirectory);

        verify(firebaseCli.deployFirestore(workingDirectory)).called(once);
      },
    );

    test(
      ".deployFirebase() deploys the functions from the given working directory",
      () async {
        await firebaseService.deployFirebase(projectId, workingDirectory);

        verify(firebaseCli.deployFunctions(workingDirectory)).called(once);
      },
    );

    test(
      ".deployHosting() sets the default Firebase project with the given project id in the given working directory",
      () async {
        await firebaseService.deployHosting(projectId, workingDirectory);

        verify(firebaseCli.setFirebaseProject(projectId, workingDirectory))
            .called(once);
      },
    );

    test(
      ".deployHosting() clears the target in the given working directory by the given target name",
      () async {
        await firebaseService.deployHosting(projectId, workingDirectory);

        verify(firebaseCli.clearTarget(projectId, workingDirectory))
            .called(once);
      },
    );

    test(
      ".deployHosting() associates the Firebase target with the given hosting name in the given working directory",
      () async {
        await firebaseService.deployHosting(projectId, workingDirectory);

        verify(firebaseCli.applyTarget(projectId, target, workingDirectory))
            .called(once);
      },
    );

    test(
      ".deployHosting() deploys a project's target from the given working directory to the Firebase hosting.",
      () async {
        await firebaseService.deployHosting(projectId, workingDirectory);

        verify(firebaseCli.deployHosting(target, workingDirectory))
            .called(once);
      },
    );

    test(".version() shows the version information", () async {
      await firebaseService.version();

      verify(firebaseCli.version()).called(once);
    });

    test(".login() throws if Firebase CLI throws during the logging", () {
      when(firebaseCli.login()).thenAnswer((_) => Future.error(stateError));

      expect(firebaseService.login(), throwsStateError);
    });

    test(
      ".addFirebase() throws if Firebase CLI throws during the Firebase capabilities adding",
      () {
        when(firebaseCli.addFirebase(projectId)).thenAnswer(
          (_) => Future.error(stateError),
        );

        expect(firebaseService.addProject(projectId), throwsStateError);
      },
    );

    test(
      ".addFirebase() stops the Firebase adding process if Firebase CLI throws during the Firestore capabilities adding",
      () async {
        when(firebaseCli.addFirebase(projectId)).thenAnswer(
          (_) => Future.error(stateError),
        );

        await expectLater(
          firebaseService.addProject(projectId),
          throwsStateError,
        );

        verify(firebaseCli.addFirebase(projectId)).called(once);
        verifyNoMoreInteractions(firebaseCli);
      },
    );

    test(
      ".addFirebase() throws if Firebase CLI throws during the web app creation",
      () {
        when(firebaseCli.createWebApp(projectId, projectId)).thenAnswer(
          (_) => Future.error(stateError),
        );

        expect(firebaseService.addProject(projectId), throwsStateError);
      },
    );

    test(
      ".addFirebase() stops the Firebase adding process if Firebase CLI throws during the web app creation",
      () async {
        when(firebaseCli.createWebApp(projectId, projectId)).thenAnswer(
          (_) => Future.error(stateError),
        );

        await expectLater(
          firebaseService.addProject(projectId),
          throwsStateError,
        );

        verify(firebaseCli.addFirebase(projectId)).called(once);
        verify(firebaseCli.createWebApp(projectId, projectId)).called(once);
        verifyNoMoreInteractions(firebaseCli);
      },
    );

    test(
      ".deployFirebase() throws if Firebase CLI throws during the default Firebase project setting",
      () {
        when(firebaseCli.setFirebaseProject(projectId, workingDirectory))
            .thenAnswer((_) => Future.error(stateError));

        expect(
          firebaseService.deployFirebase(projectId, workingDirectory),
          throwsStateError,
        );
      },
    );

    test(
      ".deployFirebase() stops the Firebase deployment process if Firebase CLI throws during the default Firebase project setting",
      () async {
        when(firebaseCli.setFirebaseProject(projectId, workingDirectory))
            .thenAnswer((_) => Future.error(stateError));

        await expectLater(
          firebaseService.deployFirebase(projectId, workingDirectory),
          throwsStateError,
        );

        verify(firebaseCli.setFirebaseProject(projectId, workingDirectory))
            .called(once);
        verifyNoMoreInteractions(firebaseCli);
      },
    );

    test(
      ".deployFirebase() throws if Firebase CLI throws during the Firestore deployment",
      () {
        when(firebaseCli.deployFirestore(workingDirectory)).thenAnswer(
          (_) => Future.error(stateError),
        );

        expect(
          firebaseService.deployFirebase(projectId, workingDirectory),
          throwsStateError,
        );
      },
    );

    test(
      ".deployFirebase() stops the Firebase deployment process if Firebase CLI throws during the Firestore deployment",
      () async {
        when(firebaseCli.deployFirestore(workingDirectory)).thenAnswer(
          (_) => Future.error(stateError),
        );

        await expectLater(
          firebaseService.deployFirebase(projectId, workingDirectory),
          throwsStateError,
        );

        verify(firebaseCli.setFirebaseProject(projectId, workingDirectory))
            .called(once);
        verify(firebaseCli.deployFirestore(workingDirectory)).called(once);
        verifyNoMoreInteractions(firebaseCli);
      },
    );

    test(
      ".deployFirebase() throws if Firebase CLI throws during the functions deployment",
      () {
        when(firebaseCli.deployFunctions(workingDirectory)).thenAnswer(
          (_) => Future.error(stateError),
        );

        expect(
          firebaseService.deployFirebase(projectId, workingDirectory),
          throwsStateError,
        );
      },
    );

    test(
      ".deployFirebase() stops the Firebase deployment process if Firebase CLI throws during the functions deployment",
      () async {
        when(firebaseCli.deployFunctions(workingDirectory)).thenAnswer(
          (_) => Future.error(stateError),
        );

        await expectLater(
          firebaseService.deployFirebase(projectId, workingDirectory),
          throwsStateError,
        );

        verify(firebaseCli.setFirebaseProject(projectId, workingDirectory))
            .called(once);
        verify(firebaseCli.deployFirestore(workingDirectory)).called(once);
        verify(firebaseCli.deployFunctions(workingDirectory)).called(once);
        verifyNoMoreInteractions(firebaseCli);
      },
    );

    test(
      ".deployHosting() throws if Firebase CLI throws during the default Firebase project setting",
      () {
        when(firebaseCli.setFirebaseProject(projectId, workingDirectory))
            .thenAnswer((_) => Future.error(stateError));

        expect(
          firebaseService.deployHosting(projectId, workingDirectory),
          throwsStateError,
        );
      },
    );

    test(
      ".deployHosting() stops the hosting deployment process if Firebase CLI throws during the default Firebase project setting",
      () async {
        when(firebaseCli.setFirebaseProject(projectId, workingDirectory))
            .thenAnswer((_) => Future.error(stateError));

        await expectLater(
          firebaseService.deployHosting(projectId, workingDirectory),
          throwsStateError,
        );

        verify(firebaseCli.setFirebaseProject(projectId, workingDirectory))
            .called(once);
        verifyNoMoreInteractions(firebaseCli);
      },
    );

    test(
      ".deployHosting() throws if Firebase CLI throws during the target clearing",
      () {
        when(firebaseCli.clearTarget(projectId, workingDirectory))
            .thenAnswer((_) => Future.error(stateError));

        expect(
          firebaseService.deployHosting(projectId, workingDirectory),
          throwsStateError,
        );
      },
    );

    test(
      ".deployHosting() stops the hosting deployment process if Firebase CLI throws during the target clearing",
      () async {
        when(firebaseCli.clearTarget(projectId, workingDirectory))
            .thenAnswer((_) => Future.error(stateError));

        await expectLater(
          firebaseService.deployHosting(projectId, workingDirectory),
          throwsStateError,
        );

        verify(firebaseCli.setFirebaseProject(projectId, workingDirectory))
            .called(once);
        verify(firebaseCli.clearTarget(projectId, workingDirectory))
            .called(once);
        verifyNoMoreInteractions(firebaseCli);
      },
    );

    test(
      ".deployHosting() throws if Firebase CLI throws during the target applying",
      () {
        when(firebaseCli.applyTarget(projectId, target, workingDirectory))
            .thenAnswer((_) => Future.error(stateError));

        expect(
          firebaseService.deployHosting(projectId, workingDirectory),
          throwsStateError,
        );
      },
    );

    test(
      ".deployHosting() stops the hosting deployment process if Firebase CLI throws during the target applying",
      () async {
        when(firebaseCli.applyTarget(projectId, target, workingDirectory))
            .thenAnswer((_) => Future.error(stateError));

        await expectLater(
          firebaseService.deployHosting(projectId, workingDirectory),
          throwsStateError,
        );

        verify(firebaseCli.setFirebaseProject(projectId, workingDirectory))
            .called(once);
        verify(firebaseCli.clearTarget(projectId, workingDirectory))
            .called(once);
        verify(firebaseCli.applyTarget(projectId, target, workingDirectory))
            .called(once);
        verifyNoMoreInteractions(firebaseCli);
      },
    );

    test(
      ".deployHosting() throws if Firebase CLI throws during the project's target deployment",
      () {
        when(firebaseCli.deployHosting(target, workingDirectory))
            .thenAnswer((_) => Future.error(stateError));

        expect(
          firebaseService.deployHosting(projectId, workingDirectory),
          throwsStateError,
        );
      },
    );

    test(
      ".deployHosting() stops the hosting deployment process if Firebase CLI throws during the project's target deployment",
      () async {
        when(firebaseCli.deployHosting(target, workingDirectory))
            .thenAnswer((_) => Future.error(stateError));

        await expectLater(
          firebaseService.deployHosting(projectId, workingDirectory),
          throwsStateError,
        );

        verify(firebaseCli.setFirebaseProject(projectId, workingDirectory))
            .called(once);
        verify(firebaseCli.clearTarget(projectId, workingDirectory))
            .called(once);
        verify(firebaseCli.applyTarget(projectId, target, workingDirectory))
            .called(once);
        verify(firebaseCli.deployHosting(target, workingDirectory))
            .called(once);
        verifyNoMoreInteractions(firebaseCli);
      },
    );

    test(
      ".version() throws if Firebase CLI throws during the version showing",
      () {
        when(firebaseCli.version()).thenAnswer((_) => Future.error(stateError));

        expect(firebaseService.version(), throwsStateError);
      },
    );
  });
}

class _FirebaseCliMock extends Mock implements FirebaseCli {}
