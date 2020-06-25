import 'dart:async';

import 'package:metrics/common/domain/entities/persistent_store_error_code.dart';
import 'package:metrics/common/domain/entities/persistent_store_exception.dart';
import 'package:metrics/common/domain/usecases/receive_project_updates.dart';
import 'package:metrics/common/presentation/models/persistent_store_error_message.dart';
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
      ".subscribeToProjects() completes normally if the receive project updates stream emits null",
      () async {
        when(receiveProjectUpdatesMock()).thenAnswer((_) => Stream.value(null));

        await expectLater(projectsNotifier.subscribeToProjects(), completes);
      },
    );

    test(
      ".subscribeToProjects() delegates to the receive project updates use case",
      () {
        when(receiveProjectUpdatesMock()).thenAnswer((_) => Stream.value(null));

        projectsNotifier.subscribeToProjects();

        verify(receiveProjectUpdatesMock()).called(equals(1));
      },
    );

    test(
      ".subscribeToProjects() subscribes to the receive project updates use case stream",
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
      ".subscribeToProjects() creates an empty list of project models if the receive project updates stream emits an empty list",
      () {
        final projectsNotifier = ProjectsNotifier(receiveProjectUpdatesMock);

        when(receiveProjectUpdatesMock()).thenAnswer((_) => Stream.value([]));

        projectsNotifier.subscribeToProjects();

        final listener = expectAsync0(() {
          expect(projectsNotifier.projectModels, isEmpty);
        });

        projectsNotifier.addListener(listener);
      },
    );

    test(
      ".projectsErrorMessage provides an error description if a project updates use case stream emits a persistent store exception",
      () async {
        const errorCode = PersistentStoreErrorCode.unknown;
        final projectsController = StreamController<List<Project>>();
        const errorMessage = PersistentStoreErrorMessage(errorCode);

        when(receiveProjectUpdatesMock()).thenAnswer(
          (_) => projectsController.stream,
        );

        projectsController.addError(
          const PersistentStoreException(code: errorCode),
        );

        final projectsNotifier = ProjectsNotifier(receiveProjectUpdatesMock);

        await projectsNotifier.subscribeToProjects();

        final listener = expectAsync0(() {
          expect(projectsNotifier.projectsErrorMessage, errorMessage.message);
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
