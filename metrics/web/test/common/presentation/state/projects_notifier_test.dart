import 'dart:async';

import 'package:flutter/services.dart';
import 'package:metrics/common/domain/usecases/receive_project_updates.dart';
import 'package:metrics/common/presentation/state/projects_notifier.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';

void main() {
  final receiveProjectUpdatesMock = ReceiveProjectUpdatesMock();
  final projectsNotifier = ProjectsNotifier(receiveProjectUpdatesMock);
  const projects = [
    Project(id: 'id1', name: 'name1'),
    Project(id: 'id2', name: 'name2'),
  ];

  tearDown(() {
    reset(receiveProjectUpdatesMock);
  });

  tearDownAll(() {
    projectsNotifier.dispose();
  });

  group("ProjectsNotifier", () {
    test(
      "throws an AssertionError if the receive project updates use case is null",
      () {
        expect(() => ProjectsNotifier(null), MatcherUtil.throwsAssertionError);
      },
    );

    test(
      ".subscribeToProjects() completes normally if the stream value from the receive project updates use case is null",
      () async {
        when(receiveProjectUpdatesMock()).thenAnswer((_) => Stream.value(null));

        await expectLater(projectsNotifier.subscribeToProjects(), completes);
      },
    );

    test(
      ".subscribeProjects() delegates to the receive project updates use case",
      () {
        when(receiveProjectUpdatesMock()).thenAnswer((_) => Stream.value(null));

        projectsNotifier.subscribeToProjects();

        verify(receiveProjectUpdatesMock()).called(equals(1));
      },
    );

    test(
      ".subscribeProjects() subscribes to project updates",
      () async {
        final projectsController = StreamController<List<Project>>();

        when(receiveProjectUpdatesMock()).thenAnswer(
          (_) => projectsController.stream,
        );

        await projectsNotifier.subscribeToProjects();

        expect(projectsController.hasListener, isTrue);
      },
    );

    test(
      ".projectsErrorMessage provides an error description if a projects stream emits a platform exception",
      () async {
        final projectsController = StreamController<List<Project>>();
        const expectedErrorMessage = 'error';

        when(receiveProjectUpdatesMock()).thenAnswer(
          (_) => projectsController.stream,
        );

        projectsController.addError(
          PlatformException(message: expectedErrorMessage, code: 'test_code'),
        );

        final projectsNotifier = ProjectsNotifier(receiveProjectUpdatesMock);

        await projectsNotifier.subscribeToProjects();

        final listener = expectAsync0(() {
          final actualError = projectsNotifier.projectsErrorMessage;

          expect(actualError, equals(expectedErrorMessage));
        });

        projectsNotifier.addListener(listener);
      },
    );

    test(
      ".unsubscribeFromProjects() unsubscribes from project updates",
      () async {
        final projectsController = StreamController<List<Project>>();

        when(receiveProjectUpdatesMock()).thenAnswer(
          (_) => projectsController.stream,
        );

        await projectsNotifier.subscribeToProjects();

        expect(projectsController.hasListener, isTrue);

        await projectsNotifier.unsubscribeFromProjects();

        expect(projectsController.hasListener, isFalse);
      },
    );

    test(
      ".unsubscribeFromProjects() clears project models",
      () async {
        final projectsNotifier = ProjectsNotifier(receiveProjectUpdatesMock);

        when(receiveProjectUpdatesMock()).thenAnswer(
          (_) => Stream.value(projects),
        );

        await expectLater(projectsNotifier.subscribeToProjects(), completes);

        expect(projectsNotifier.projectModels, isNotNull);

        await projectsNotifier.unsubscribeFromProjects();

        expect(projectsNotifier.projectModels, isNull);
      },
    );

    test(
      ".dispose() cancels projects subscription",
      () async {
        final projectsNotifier = ProjectsNotifier(receiveProjectUpdatesMock);

        final projectsController = StreamController<List<Project>>();

        when(receiveProjectUpdatesMock()).thenAnswer(
          (_) => projectsController.stream,
        );

        await projectsNotifier.subscribeToProjects();

        expect(projectsController.hasListener, isTrue);

        projectsNotifier.dispose();

        expect(projectsController.hasListener, isFalse);
      },
    );
  });
}

class ReceiveProjectUpdatesMock extends Mock implements ReceiveProjectUpdates {}
