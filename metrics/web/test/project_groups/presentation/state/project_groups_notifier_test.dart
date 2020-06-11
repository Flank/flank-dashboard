import 'dart:async';

import 'package:flutter/services.dart';
import 'package:metrics/common/presentation/constants/common_constants.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/project_groups/domain/entities/project_group.dart';
import 'package:metrics/project_groups/domain/usecases/add_project_group_usecase.dart';
import 'package:metrics/project_groups/domain/usecases/delete_project_group_usecase.dart';
import 'package:metrics/project_groups/domain/usecases/parameters/add_project_group_param.dart';
import 'package:metrics/project_groups/domain/usecases/parameters/delete_project_group_param.dart';
import 'package:metrics/project_groups/domain/usecases/parameters/update_project_group_param.dart';
import 'package:metrics/project_groups/domain/usecases/receive_project_group_updates.dart';
import 'package:metrics/project_groups/domain/usecases/update_project_group_usecase.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/subjects.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';

void main() {
  group("ProjectGroupsNotifier", () {
    const projectGroupId = 'testId';
    const projectGroupName = 'testName';
    const projectIds = ['testProjectId'];

    final addProjectGroupUseCase = AddProjectGroupUseCaseMock();
    final updateProjectGroupUseCase = UpdateProjectGroupUseCaseMock();
    final deleteProjectGroupUseCase = DeleteProjectGroupUseCaseMock();
    final receiveProjectGroupUpdates = ReceiveProjectGroupUpdatesMock();

    final projectGroupsNotifier = ProjectGroupsNotifier(
      receiveProjectGroupUpdates,
      addProjectGroupUseCase,
      updateProjectGroupUseCase,
      deleteProjectGroupUseCase,
    );

    tearDown(() {
      reset(addProjectGroupUseCase);
      reset(updateProjectGroupUseCase);
      reset(deleteProjectGroupUseCase);
      reset(receiveProjectGroupUpdates);
    });

    tearDownAll(() {
      projectGroupsNotifier.dispose();
    });

    test(
      "throws an AssertionError if the receive project group updates use case is null",
      () {
        expect(
          () => ProjectGroupsNotifier(
            null,
            addProjectGroupUseCase,
            updateProjectGroupUseCase,
            deleteProjectGroupUseCase,
          ),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      "throws an AssertionError if the add project group use case is null",
      () {
        expect(
          () => ProjectGroupsNotifier(
            receiveProjectGroupUpdates,
            null,
            updateProjectGroupUseCase,
            deleteProjectGroupUseCase,
          ),
          MatcherUtil.throwsAssertionError,
        );
      },
    );
    test(
      "throws an AssertionError if the update project group use case is null",
      () {
        expect(
          () => ProjectGroupsNotifier(
            receiveProjectGroupUpdates,
            addProjectGroupUseCase,
            null,
            deleteProjectGroupUseCase,
          ),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      "throws an AssertionError if the delete project group use case is null",
      () {
        expect(
          () => ProjectGroupsNotifier(
            receiveProjectGroupUpdates,
            addProjectGroupUseCase,
            updateProjectGroupUseCase,
            null,
          ),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      ".subscribeToProjectGroups() completes normally if a receiveProjectGroupUpdates is null",
      () async {
        when(receiveProjectGroupUpdates()).thenAnswer(
          (_) => Stream.value(null),
        );

        await expectLater(
          projectGroupsNotifier.subscribeToProjectGroups(),
          completes,
        );

        final projectGroups = projectGroupsNotifier.projectGroups;

        expect(projectGroups, isNull);
      },
    );

    test(
      ".subscribeToProjectGroups() delegates to the receiveProjectGroupUpdates usecase",
      () {
        when(receiveProjectGroupUpdates.call())
            .thenAnswer((realInvocation) => const Stream.empty());

        projectGroupsNotifier.subscribeToProjectGroups();

        verify(receiveProjectGroupUpdates.call()).called(equals(1));
      },
    );

    test(
      ".subscribeToProjectGroups() subscribes to project groups updates",
      () async {
        final projectGroupsController = StreamController<List<ProjectGroup>>();

        when(receiveProjectGroupUpdates.call()).thenAnswer(
          (_) => projectGroupsController.stream,
        );

        await projectGroupsNotifier.subscribeToProjectGroups();

        expect(projectGroupsController.hasListener, isTrue);
      },
    );

    test(
      ".errorMessage provides an error description if project groups stream emits a PlatformException",
      () async {
        final projectGroupsController = BehaviorSubject<List<ProjectGroup>>();
        const errorMessage = 'errorMessage';

        when(receiveProjectGroupUpdates())
            .thenAnswer((_) => projectGroupsController.stream);

        final projectGroupsNotifier = ProjectGroupsNotifier(
          receiveProjectGroupUpdates,
          addProjectGroupUseCase,
          updateProjectGroupUseCase,
          deleteProjectGroupUseCase,
        );

        await projectGroupsNotifier.subscribeToProjectGroups();

        projectGroupsController.addError(PlatformException(
          message: errorMessage,
          code: 'test_code',
        ));

        bool hasErrorDescription;
        final metricsListener = expectAsyncUntil0(() async {
          hasErrorDescription =
              projectGroupsNotifier.errorMessage == errorMessage;

          if (hasErrorDescription) projectGroupsNotifier.dispose();
        }, () => hasErrorDescription);

        projectGroupsNotifier.addListener(metricsListener);
      },
    );

    test(
      ".errorMessage provides an error description if project groups stream emits an unknown Exception",
      () async {
        final projectGroupsController = BehaviorSubject<List<ProjectGroup>>();
        const errorMessage = CommonStrings.unknownErrorMessage;

        when(receiveProjectGroupUpdates())
            .thenAnswer((_) => projectGroupsController.stream);

        final projectGroupsNotifier = ProjectGroupsNotifier(
          receiveProjectGroupUpdates,
          addProjectGroupUseCase,
          updateProjectGroupUseCase,
          deleteProjectGroupUseCase,
        );

        await projectGroupsNotifier.subscribeToProjectGroups();

        projectGroupsController.addError(Exception());

        bool hasErrorDescription;
        final metricsListener = expectAsyncUntil0(() async {
          hasErrorDescription =
              projectGroupsNotifier.errorMessage == errorMessage;

          if (hasErrorDescription) projectGroupsNotifier.dispose();
        }, () => hasErrorDescription);

        projectGroupsNotifier.addListener(metricsListener);
      },
    );

    test(".deleteProjectGroup() delegates to the DeleteProjectGroupUseCase",
        () {
      projectGroupsNotifier.deleteProjectGroup(projectGroupId);

      verify(
        deleteProjectGroupUseCase(
          const DeleteProjectGroupParam(projectGroupId: projectGroupId),
        ),
      ).called(1);
    });

    test(
        ".saveProjectGroup() delegates to the UpdateProjectGroupUseCase if the projectGroupId is not null",
        () {
      projectGroupsNotifier.saveProjectGroup(
        projectGroupId,
        projectGroupName,
        projectIds,
      );

      verify(
        updateProjectGroupUseCase(
          const UpdateProjectGroupParam(
            projectGroupId,
            projectGroupName,
            projectIds,
          ),
        ),
      ).called(1);
    });

    test(
      ".saveProjectGroup() delegates to the AddProjectGroupUseCase if the projectGroupId is null",
      () {
        projectGroupsNotifier.saveProjectGroup(
          null,
          projectGroupName,
          projectIds,
        );

        verify(
          addProjectGroupUseCase(
            const AddProjectGroupParam(
              projectGroupName: projectGroupName,
              projectIds: projectIds,
            ),
          ),
        ).called(1);
      },
    );
    test(".saveProjectGroup() returns true if completes successfully",
        () async {
      final result = await projectGroupsNotifier.saveProjectGroup(
        null,
        projectGroupName,
        projectIds,
      );

      expect(result, isTrue);
    });

    test(".saveProjectGroup() returns false if throws an Exception", () async {
      when(addProjectGroupUseCase(any)).thenThrow(Exception());

      final result = await projectGroupsNotifier.saveProjectGroup(
        null,
        projectGroupName,
        projectIds,
      );

      expect(result, isFalse);
    });

    test(
      ".generateActiveProjectGroupViewModel() update project selector view models",
      () {
        const testProjectId = 'testProjectId';
        const testProjectGroupId = 'testGroupId';
        when(receiveProjectGroupUpdates()).thenAnswer(
          (_) => Stream.value([
            const ProjectGroup(id: 'id', name: 'name', projectIds: []),
            const ProjectGroup(
                id: testProjectGroupId,
                name: 'name',
                projectIds: [testProjectId]),
          ]),
        );

        final projectGroupsNotifier = ProjectGroupsNotifier(
          receiveProjectGroupUpdates,
          addProjectGroupUseCase,
          updateProjectGroupUseCase,
          deleteProjectGroupUseCase,
        );

        projectGroupsNotifier.subscribeToProjectGroups();

        projectGroupsNotifier.updateProjects(const [
          Project(id: testProjectId, name: '1'),
        ], null);

        expect(
          projectGroupsNotifier.projectSelectorViewModels.first.isChecked,
          false,
        );

        Timer timer;

        bool projectSelectorViewModelIsChecked = false;
        final projectGroupListener = expectAsyncUntil0(() {
          if (projectGroupsNotifier.projectGroups != null) {
            projectGroupsNotifier
                .generateActiveProjectGroupViewModel(testProjectGroupId);
            final projectSelectorViewModel =
                projectGroupsNotifier.projectSelectorViewModels.first;
            projectSelectorViewModelIsChecked =
                projectSelectorViewModel.isChecked;
            timer?.cancel();
            projectGroupsNotifier.dispose();
          }
        }, () => projectSelectorViewModelIsChecked);

        timer = Timer.periodic(
          const Duration(seconds: 1),
          (timer) => projectGroupListener(),
        );
      },
    );

    test(
      ".generateActiveProjectGroupViewModel() generate new active project group view model by id",
      () {
        const testProjectGroupId = 'testGroupId';

        when(receiveProjectGroupUpdates()).thenAnswer(
          (_) => Stream.value([
            const ProjectGroup(id: 'id', name: 'name', projectIds: []),
            const ProjectGroup(
              id: testProjectGroupId,
              name: 'name',
              projectIds: [],
            ),
          ]),
        );

        final projectGroupsNotifier = ProjectGroupsNotifier(
          receiveProjectGroupUpdates,
          addProjectGroupUseCase,
          updateProjectGroupUseCase,
          deleteProjectGroupUseCase,
        );

        projectGroupsNotifier.subscribeToProjectGroups();

        projectGroupsNotifier.updateProjects(const [
          Project(id: 'id', name: 'name'),
        ], null);

        expect(projectGroupsNotifier.activeProjectGroupDialogViewModel, isNull);

        Timer timer;

        bool activeProjectGroupDialogViewModelIsNotNull = false;
        final projectGroupListener = expectAsyncUntil0(() {
          if (projectGroupsNotifier.projectGroups != null) {
            projectGroupsNotifier
                .generateActiveProjectGroupViewModel(testProjectGroupId);
            activeProjectGroupDialogViewModelIsNotNull =
                projectGroupsNotifier.activeProjectGroupDialogViewModel != null;
            timer?.cancel();
            projectGroupsNotifier.dispose();
          }
        }, () => activeProjectGroupDialogViewModelIsNotNull);

        timer = Timer.periodic(
          const Duration(seconds: 1),
          (timer) => projectGroupListener(),
        );
      },
    );

    test(
      ".generateActiveProjectGroupViewModel() resets project name filter",
      () async {
        const testProjectGroupId = 'testGroupId';
        const filteredProjectName = 'filteredProjectName';
        const expectedFilteredProjectsLength = 1;
        const testProjects = [
          Project(id: 'id1', name: 'name'),
          Project(id: 'id2', name: filteredProjectName),
        ];

        when(receiveProjectGroupUpdates()).thenAnswer(
          (_) => Stream.value([
            const ProjectGroup(id: 'id', name: 'name', projectIds: []),
            const ProjectGroup(
              id: testProjectGroupId,
              name: 'name',
              projectIds: [],
            ),
          ]),
        );

        final projectGroupsNotifier = ProjectGroupsNotifier(
          receiveProjectGroupUpdates,
          addProjectGroupUseCase,
          updateProjectGroupUseCase,
          deleteProjectGroupUseCase,
        );

        await projectGroupsNotifier.subscribeToProjectGroups();

        projectGroupsNotifier.subscribeToProjectsNameFilter();

        projectGroupsNotifier.updateProjects(testProjects, null);

        projectGroupsNotifier.filterByProjectName(filteredProjectName);

        await Future.delayed(
          Duration(
              milliseconds: DurationConstants.debounce.inMilliseconds + 100),
        );

        expect(projectGroupsNotifier.projectSelectorViewModels.length,
            expectedFilteredProjectsLength);

        Timer timer;

        bool isFilterReset = false;
        final projectGroupListener = expectAsyncUntil0(() {
          if (projectGroupsNotifier.projectGroups != null) {
            projectGroupsNotifier
                .generateActiveProjectGroupViewModel(testProjectGroupId);
            isFilterReset =
                projectGroupsNotifier.projectSelectorViewModels.length ==
                    testProjects.length;
            timer?.cancel();
            projectGroupsNotifier.dispose();
          }
        }, () => isFilterReset);

        timer = Timer.periodic(
          const Duration(seconds: 1),
          (timer) => projectGroupListener(),
        );
      },
    );

    test(
      ".toggleProjectCheckedStatus() adds the given projectId to the active project group dialog projectIds field if is checked",
      () {
        const testProjectGroupId = 'testGroupId';
        const testProjectId = 'testProjectId';

        when(receiveProjectGroupUpdates()).thenAnswer(
          (_) => Stream.value([
            const ProjectGroup(id: 'id', name: 'name', projectIds: []),
            const ProjectGroup(
              id: testProjectGroupId,
              name: 'name',
              projectIds: [],
            ),
          ]),
        );

        final projectGroupsNotifier = ProjectGroupsNotifier(
          receiveProjectGroupUpdates,
          addProjectGroupUseCase,
          updateProjectGroupUseCase,
          deleteProjectGroupUseCase,
        );

        projectGroupsNotifier.subscribeToProjectGroups();

        projectGroupsNotifier.updateProjects(const [
          Project(id: testProjectId, name: 'name'),
        ], null);

        Timer timer;

        bool projectIdIsAdded = false;
        final projectGroupListener = expectAsyncUntil0(() {
          if (projectGroupsNotifier.projectGroups != null) {
            projectGroupsNotifier
                .generateActiveProjectGroupViewModel(testProjectGroupId);
            projectGroupsNotifier.toggleProjectCheckedStatus(
                projectId: testProjectId, isChecked: true);
            final newActiveViewModel =
                projectGroupsNotifier.activeProjectGroupDialogViewModel;
            projectIdIsAdded =
                newActiveViewModel.selectedProjectIds.contains(testProjectId);
            timer?.cancel();
            projectGroupsNotifier.dispose();
          }
        }, () => projectIdIsAdded);

        timer = Timer.periodic(
          const Duration(seconds: 1),
          (timer) => projectGroupListener(),
        );
      },
    );

    test(
      ".toggleProjectCheckedStatus() removes the given projectId from the active project group dialog projectIds field if is not checked",
      () {
        const testProjectGroupId = 'testGroupId';
        const testProjectId = 'testProjectId';

        when(receiveProjectGroupUpdates()).thenAnswer(
          (_) => Stream.value([
            const ProjectGroup(id: 'id', name: 'name', projectIds: []),
            const ProjectGroup(
              id: testProjectGroupId,
              name: 'name',
              projectIds: [testProjectId],
            ),
          ]),
        );

        final projectGroupsNotifier = ProjectGroupsNotifier(
          receiveProjectGroupUpdates,
          addProjectGroupUseCase,
          updateProjectGroupUseCase,
          deleteProjectGroupUseCase,
        );

        projectGroupsNotifier.subscribeToProjectGroups();

        projectGroupsNotifier.updateProjects(const [
          Project(id: testProjectId, name: 'name'),
        ], null);

        Timer timer;

        bool projectIdIsRemoved = false;
        final projectGroupListener = expectAsyncUntil0(() {
          if (projectGroupsNotifier.projectGroups != null) {
            projectGroupsNotifier
                .generateActiveProjectGroupViewModel(testProjectGroupId);
            projectGroupsNotifier.toggleProjectCheckedStatus(
                projectId: testProjectId, isChecked: false);
            final newActiveViewModel =
                projectGroupsNotifier.activeProjectGroupDialogViewModel;
            projectIdIsRemoved =
                !newActiveViewModel.selectedProjectIds.contains(testProjectId);
            timer?.cancel();
            projectGroupsNotifier.dispose();
          }
        }, () => projectIdIsRemoved);

        timer = Timer.periodic(
          const Duration(seconds: 1),
          (timer) => projectGroupListener(),
        );
      },
    );

    test(
      ".toggleProjectCheckedStatus() changes project selector view model is checked status to the given by id",
      () {
        const testProjectGroupId = 'testGroupId';
        const testProjectId = 'testProjectId';

        when(receiveProjectGroupUpdates()).thenAnswer(
          (_) => Stream.value([
            const ProjectGroup(id: 'id', name: 'name', projectIds: []),
            const ProjectGroup(
              id: testProjectGroupId,
              name: 'name',
              projectIds: [],
            ),
          ]),
        );

        final projectGroupsNotifier = ProjectGroupsNotifier(
          receiveProjectGroupUpdates,
          addProjectGroupUseCase,
          updateProjectGroupUseCase,
          deleteProjectGroupUseCase,
        );

        projectGroupsNotifier.subscribeToProjectGroups();

        projectGroupsNotifier.updateProjects(const [
          Project(id: testProjectId, name: 'name'),
        ], null);

        Timer timer;

        bool projectSelectorIsChecked = false;
        final projectGroupListener = expectAsyncUntil0(() {
          if (projectGroupsNotifier.projectGroups != null) {
            projectGroupsNotifier
                .generateActiveProjectGroupViewModel(testProjectGroupId);
            projectGroupsNotifier.toggleProjectCheckedStatus(
                projectId: testProjectId, isChecked: true);
            final projectSelectorViewModel =
                projectGroupsNotifier.projectSelectorViewModels.firstWhere(
              (project) => project.id == testProjectId,
            );
            projectSelectorIsChecked = projectSelectorViewModel.isChecked;
            timer?.cancel();
            projectGroupsNotifier.dispose();
          }
        }, () => projectSelectorIsChecked);

        timer = Timer.periodic(
          const Duration(seconds: 1),
          (timer) => projectGroupListener(),
        );
      },
    );

    test(".deleteProjectGroup() returns true if completes successfully",
        () async {
      final result = await projectGroupsNotifier.deleteProjectGroup(
        projectGroupId,
      );

      expect(result, isTrue);
    });

    test(".deleteProjectGroup() returns false if throws an Exception",
        () async {
      when(deleteProjectGroupUseCase(any)).thenThrow(Exception());

      final result =
          await projectGroupsNotifier.deleteProjectGroup(projectGroupId);

      expect(result, isFalse);
    });

    test(
      ".saveProjectGroup() sets the firestore error message if the AddProjectGroupUseCase throws",
      () async {
        when(addProjectGroupUseCase(any)).thenThrow(Exception());

        await projectGroupsNotifier.saveProjectGroup(
          null,
          projectGroupName,
          projectIds,
        );

        expect(
          projectGroupsNotifier.firestoreWriteErrorMessage,
          equals(CommonStrings.unknownErrorMessage),
        );
      },
    );

    test(
      ".saveProjectGroup() sets the firestore error message if the UpdateProjectGroupUseCase throws",
      () async {
        when(updateProjectGroupUseCase(any)).thenThrow(Exception());

        await projectGroupsNotifier.saveProjectGroup(
          projectGroupId,
          projectGroupName,
          projectIds,
        );

        expect(
          projectGroupsNotifier.firestoreWriteErrorMessage,
          equals(CommonStrings.unknownErrorMessage),
        );
      },
    );

    test(
      ".deleteProjectGroup() sets the firestore error message if the DeleteProjectGroupUseCase throws",
      () async {
        when(deleteProjectGroupUseCase(any)).thenThrow(Exception());

        await projectGroupsNotifier.deleteProjectGroup(projectGroupId);

        expect(
          projectGroupsNotifier.firestoreWriteErrorMessage,
          equals(CommonStrings.unknownErrorMessage),
        );
      },
    );

    test(
      ".resetFirestoreWriteErrorMessage() sets an error message to null",
      () async {
        when(addProjectGroupUseCase(any)).thenThrow(Exception());

        await projectGroupsNotifier.saveProjectGroup(
          null,
          projectGroupName,
          projectIds,
        );

        expect(
          projectGroupsNotifier.firestoreWriteErrorMessage,
          equals(CommonStrings.unknownErrorMessage),
        );

        projectGroupsNotifier.resetFirestoreWriteErrorMessage();

        expect(projectGroupsNotifier.firestoreWriteErrorMessage, isNull);
      },
    );

    test(
      ".unsubscribeFromProjectGroups() cancels all created subscriptions and clear project groups",
      () async {
        when(receiveProjectGroupUpdates()).thenAnswer(
          (_) => Stream.value([
            const ProjectGroup(id: 'id', name: 'name', projectIds: []),
            const ProjectGroup(id: 'id', name: 'name', projectIds: []),
          ]),
        );

        final projectGroupsNotifier = ProjectGroupsNotifier(
          receiveProjectGroupUpdates,
          addProjectGroupUseCase,
          updateProjectGroupUseCase,
          deleteProjectGroupUseCase,
        );

        await expectLater(
          projectGroupsNotifier.subscribeToProjectGroups(),
          completes,
        );

        expect(projectGroupsNotifier.projectGroups, isNotNull);

        await projectGroupsNotifier.unsubscribeFromProjectGroups();

        expect(projectGroupsNotifier.projectGroups, isNull);
      },
    );

    test(
      ".dispose() cancels all created subscriptions",
      () async {
        final projectGroupsNotifier = ProjectGroupsNotifier(
          receiveProjectGroupUpdates,
          addProjectGroupUseCase,
          updateProjectGroupUseCase,
          deleteProjectGroupUseCase,
        );

        final projectGroupsController = StreamController<List<ProjectGroup>>();

        when(receiveProjectGroupUpdates()).thenAnswer(
          (_) => projectGroupsController.stream,
        );

        await projectGroupsNotifier.subscribeToProjectGroups();

        expect(projectGroupsController.hasListener, isTrue);

        projectGroupsNotifier.dispose();

        expect(projectGroupsController.hasListener, isFalse);
      },
    );
  });
}

class AddProjectGroupUseCaseMock extends Mock
    implements AddProjectGroupUseCase {}

class UpdateProjectGroupUseCaseMock extends Mock
    implements UpdateProjectGroupUseCase {}

class DeleteProjectGroupUseCaseMock extends Mock
    implements DeleteProjectGroupUseCase {}

class ReceiveProjectGroupUpdatesMock extends Mock
    implements ReceiveProjectGroupUpdates {}
